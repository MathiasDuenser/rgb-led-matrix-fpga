//****************************************************************************
// X-1 (http://x-1.at)
//
// Project:     RGB LED Matrix
// Module:      Line
// Author:      Mathias Duenser (MaDu)
//
// ChangeLog:
//  V01 MaDu 25.03.2016
//      -- Initial Release
//****************************************************************************

module rgb_fpga_line (
    // ---------------- INPUT PORT DECLARATIONS --------------------
    input               rst_n,      // asynchronous reset (active low)
    input               clk,        // system clock
    input               enable,     // enable of the block
    input               line_start, // start strobe
    input [31:0][7:0]   data,       // data for one line (8 Bit)
    // ---------------- OUTPUT PORT DECLARATIONS -------------------
    
    
    output logic        clk_o,      // output clock for shift register
    output logic        line_o,     // line output data signal
    output logic        line_lat,   // line latch signal
    output logic        line_oe,    // line output enable signal
    output logic        line_rdy    // line data was streamed out
);
    
    logic   [7:0]       pwm_cnt;
    bit     [31:0]      col_cnt;
    
    always_ff @ (negedge rst_n or posedge clk) begin : pwm_counter
        if (!rst_n) begin
            pwm_cnt <= 8'd0;                                        // default
        end else begin
            if(!enable)
                pwm_cnt <= 8'd0;
            else
                if(clk_o) begin
                    if(pwm_cnt == 8'd255 && (col_cnt == 5'd31))         // endless loop
                        pwm_cnt <= 8'd0;
                    else if(pwm_cnt < 8'd255 && (col_cnt == 5'd31))     // overflow protection and control signal
                        pwm_cnt <= pwm_cnt + 8'd1;
                end
        end
    end : pwm_counter
    
    always_ff @ (negedge rst_n or posedge clk) begin : col_counter
        if (!rst_n) begin
            col_cnt <= 5'd0;                                        // default set to all ones (short '1)
        end else begin
            if(!enable)
                col_cnt <= 5'd0;
            else
                if(clk_o) begin
                    if(col_cnt < 5'd31)                                 // overflow protection and control signal
                        col_cnt <= col_cnt + 5'd1;
                    else if (clk_o)
                        col_cnt <= 5'd0;
                end
        end
    end : col_counter

    assign line_o = (enable) ? (data[col_cnt] > pwm_cnt) : 5'd0;
    
    always_ff @ (negedge rst_n or posedge clk) begin : clk_generator
        if (!rst_n) begin
            clk_o <= 1'b0;          // default
        end else begin
            if(!enable)
                clk_o <= 1'b0;
            else
                if(!line_rdy && !line_lat)
                    clk_o <= !clk_o;
                else
                    clk_o <= 1'b0;
        end
    end : clk_generator
    
    always_ff @ (negedge rst_n or posedge clk) begin : line_latch
        if (!rst_n) begin
            line_lat <= 1'b0;          // default
        end else begin
            if(!enable)
                line_lat <= 1'b0;
            else
                if(col_cnt == 5'd31 && clk_o) begin
                    line_lat <= 1'b1;
                end else begin
                    line_lat <= 1'b0;
                end
        end
    end : line_latch
    
    always_ff @ (negedge rst_n or posedge clk) begin : line_output_enable
        if (!rst_n) begin
            line_oe <= 1'b0;          // default
        end else begin
            if(!enable)
                line_oe <= 1'b0;
            else
                if(((col_cnt == 5'd31) && clk_o) || line_lat)
                    line_oe <= 1'b0;
                else
                    line_oe <= 1'b1;
        end
    end : line_output_enable
    
    always_ff @ (negedge rst_n or posedge clk) begin : line_ready
        if (!rst_n) begin
            line_rdy <= 1'b1;       // default
        end else begin
            if(!enable)
                line_rdy <= 1'b1;
            else
                if(line_start)
                    line_rdy <= 1'b0;
                if(pwm_cnt == 8'd255 && (col_cnt == 5'd31) && clk_o)
                    line_rdy <= 1'b1;
        end
    end : line_ready
    
   
endmodule
