//****************************************************************************
// X-1 (http://x-1.at)
//
// Project:     RGB LED Matrix
// Module:      Toplevel
// Author:      Mathias Duenser (MaDu)
//
// ChangeLog:
//  V02 MaDu 27.03.2016
//      -- Added line_start as an output for better debugging with logic analyzer
//  V01 MaDu 23.03.2016
//      -- Initial Release
//****************************************************************************

module rgb_fpga_toplevel (
    // ---------------- INPUT PORT DECLARATIONS --------------------
    input               rst_n,      // asynchronous reset (active low)
    input               clk,        // system clock
    input               enable,     // enable of the block
    // ---------------- OUTPUT PORT DECLARATIONS -------------------
    output logic        matrix_r0,  // r0 line (red #0)
    output logic        matrix_g0,  // matrix g0 line (green #0)
    output logic        matrix_b0,  // matrix b0 line (blue #0)
    output logic        matrix_r1,  // matrix r0 line (red #1)
    output logic        matrix_g1,  // matrix g0 line (green #1)
    output logic        matrix_b1,  // matrix b0 line (blue #1)
    output logic        matrix_clk, // matrix clock line
    output logic        matrix_oe,  // matrix output enable line
    output logic        matrix_lat, // matrix latch line
    output logic [3:0]  matrix_addr,// matrix line address (sometimes A,B,C,D)
    output logic        line_start  // set when a line starts (only for debugging with logic analyzer)
);
    
    logic [31:0][7:0] data;         // r0 memory (just for testing)
    logic [31:0][7:0] data_g;       // g0 memory (just for testing)
    logic       line_rdy;
    //logic       line_start;       // not required if signal is defined as output (only during debugging)
    logic       frame_rdy;
    
    assign data = {8'd1,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
                     8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
                     8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
                     8'd0,8'd0,8'd0,8'd0,8'd0,8'd4,8'd2,8'd0}; // PWM values for one line, 8 Bit depth
    assign data_g = {8'd1,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
                     8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
                     8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,8'd0,
                     8'd0,8'd0,8'd0,8'd0,8'd0,8'd3,8'd0,8'd1}; // PWM values for one line, 8 Bit depth
    
    rgb_fpga_display_ctrl   o_rgp_fpga_display_ctrl(
        .rst_n          (rst_n),                // asynchronous reset
        .clk            (clk),                  // system clock
        .enable         (enable),               // enable signal
        .line_rdy       (line_rdy),             // line ready strobe
        .line_start     (line_start),           // line start strobe
        .frame_rdy      (frame_rdy),            // frame ready strobe
        .matrix_addr    (matrix_addr)           // matrix line address
    );
    
    rgb_fpga_line   o_rgb_fpga_line_red_0(
        .rst_n          (rst_n),                // asynchronous reset
        .clk            (clk),                  // system clock
        .enable         (enable),               // enable signal
        .line_start     (line_start),           // line start strobe
        .data           (data),                 // data for one line (32 x 8 Bit)
        .clk_o          (matrix_clk),           // output clock for shift register
        .line_o         (matrix_r0),            // line output data signal
        .line_lat       (matrix_lat),           // line latch signal
        .line_oe        (matrix_oe),            // line output enable signal
        .line_rdy       (line_rdy)              // line ready strobe (whole line was streamed out)
    );
    
    rgb_fpga_line   o_rgb_fpga_line_green_0(
        .rst_n          (rst_n),                // asynchronous reset
        .clk            (clk),                  // system clock
        .enable         (enable),               // enable signal
        .line_start     (line_start),           // line start strobe
        .data           (data_g),               // data for one line (32 x 8 Bit)
        .clk_o          (),                     // output clock for shift register
        .line_o         (matrix_g0),            // line output data signal
        .line_lat       (),                     // line latch signal
        .line_oe        (),                     // line output enable signal
        .line_rdy       ()                      // line ready strobe (whole line was streamed out)
    );
    
    rgb_fpga_line   o_rgb_fpga_line_blue_0(
        .rst_n          (rst_n),                // asynchronous reset
        .clk            (clk),                  // system clock
        .enable         (enable),               // enable signal
        .line_start     (line_start),           // line start strobe
        .data           (data),                 // data for one line (32 x 8 Bit)
        .clk_o          (),                     // output clock for shift register
        .line_o         (matrix_b0),            // line output data signal
        .line_lat       (),                     // line latch signal
        .line_oe        (),                     // line output enable signal
        .line_rdy       ()                      // line ready strobe (whole line was streamed out)
    );
    
    rgb_fpga_line   o_rgb_fpga_line_red_1(
        .rst_n          (rst_n),                // asynchronous reset
        .clk            (clk),                  // system clock
        .enable         (enable),               // enable signal
        .line_start     (line_start),           // line start strobe
        .data           (data),                 // data for one line (32 x 8 Bit)
        .clk_o          (),                     // output clock for shift register
        .line_o         (matrix_r1),            // line output data signal
        .line_lat       (),                     // line latch signal
        .line_oe        (),                     // line output enable signal
        .line_rdy       ()                      // line ready strobe (whole line was streamed out)
    );
    
    rgb_fpga_line   o_rgb_fpga_line_green_1(
        .rst_n          (rst_n),                // asynchronous reset
        .clk            (clk),                  // system clock
        .enable         (enable),               // enable signal
        .line_start     (line_start),           // line start strobe
        .data           (data),                 // data for one line (32 x 8 Bit)
        .clk_o          (),                     // output clock for shift register
        .line_o         (matrix_g1),            // line output data signal
        .line_lat       (),                     // line latch signal
        .line_oe        (),                     // line output enable signal
        .line_rdy       ()                      // line ready strobe (whole line was streamed out)
    );
    
    rgb_fpga_line   o_rgb_fpga_line_blue_1(
        .rst_n          (rst_n),                // asynchronous reset
        .clk            (clk),                  // system clock
        .enable         (enable),               // enable signal
        .line_start     (line_start),           // line start strobe
        .data           (data),                 // data for one line (32 x 8 Bit)
        .clk_o          (),                     // output clock for shift register
        .line_o         (matrix_b1),            // line output data signal
        .line_lat       (),                     // line latch signal
        .line_oe        (),                     // line output enable signal
        .line_rdy       ()                      // line ready strobe (whole line was streamed out)
    );
    
endmodule
