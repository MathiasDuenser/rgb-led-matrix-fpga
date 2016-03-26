//****************************************************************************
// Speedyweb.at
//
// Project:    RGB LED Matrix
// Module:     Display Control
// ChangeLog:
//  V01 MaDu 26.03.2016
//      -- Initial Release
//****************************************************************************

module rgb_fpga_display_ctrl (
    // ---------------- INPUT PORT DECLARATIONS --------------------
    input               rst_n,          // asynchronous reset (active low)
    input               clk,            // system clock
    input               enable,         // enable of block
    input               line_rdy,       // line is ready
    
    // ---------------- OUTPUT PORT DECLARATIONS -------------------
	    
    output logic        line_start, // start line
    output logic        frame_rdy,  // one frame done
    output logic [3:0]  matrix_addr  // line output data signal
);

    logic matrix_addr_increase;
    logic matrix_addr_reset;

    // Address counter (0-15)   
    always_ff @ (posedge clk or negedge rst_n) begin : address_counter
        if (!rst_n)
            matrix_addr <= 4'd0;
        else begin
            if(matrix_addr_reset)
                matrix_addr <= 4'd0;
            else begin
                if(matrix_addr_increase && !(&matrix_addr))                     // overflow protection
                    matrix_addr <= matrix_addr + 4'd1;
            end
        end
    end : address_counter
    
    // ----------------------------------------------------------------
    // FSM: Display Control, States
    // ----------------------------------------------------------------
    
    enum logic [2:0] {
        IDLE            =   3'd0,
        RUNNING         =   3'd1,
        NEXT_LINE       =   3'd2,
        NEXT_FRAME      =   3'd3
    } fsm_display_ctrl_current_state, fsm_display_ctrl_next_state;
    
    // ----------------------------------------------------------------
    // FSM: Display Control sequential part
    // ----------------------------------------------------------------
    
    always_ff @ (posedge clk or negedge rst_n) begin : display_ctrl_seq
        if (!rst_n)     fsm_display_ctrl_current_state <= IDLE;
        else            fsm_display_ctrl_current_state <= fsm_display_ctrl_next_state;    // normal fsm operation
    end

    // ----------------------------------------------------------------
    // FSM: Display Control combinatorial part
    // ----------------------------------------------------------------
    
    always_comb begin : display_ctrl_comb
        
        // -------------------------
        // FSM default output values
        // -------------------------
        line_start                  = 1'b0;
        matrix_addr_reset            = 1'b0;
        matrix_addr_increase         = 1'b0;
        frame_rdy                   = 1'b0;
        fsm_display_ctrl_next_state = fsm_display_ctrl_current_state;
    
        // ===============================================================
        // FSM state transitions
        // ===============================================================
        
        case ( fsm_display_ctrl_next_state )  
            // ----------------------------------------------------------------
            // IDLE - default after reset or disabling (wait for enable)
            // ----------------------------------------------------------------
            IDLE            :   begin
                                    matrix_addr_reset = 1'b1;
                                    if(enable) begin                            // module is enabled
                                        line_start = 1'b1;
                                        fsm_display_ctrl_next_state = RUNNING;
                                    end else begin
                                        fsm_display_ctrl_next_state = IDLE;        // Nothing happened, stay here
                                    end
                                end
            
            // ----------------------------------------------------------------
            // RUNNING
            // ----------------------------------------------------------------
            RUNNING         :   if(!enable) begin                               // module is disabled
                                    fsm_display_ctrl_next_state = IDLE;
                                end else if(line_rdy) begin                     // current line is completed
                                    fsm_display_ctrl_next_state = NEXT_LINE;
                                end
            NEXT_LINE       :   if(!enable) begin
                                    fsm_display_ctrl_next_state = IDLE;
                                end else begin
                                    if(matrix_addr < 4'd15) begin
                                        matrix_addr_increase = 1'b1;
                                        line_start = 1'b1;
                                        fsm_display_ctrl_next_state = RUNNING;
                                    end else begin
                                        matrix_addr_reset = 1'b1;
                                        frame_rdy = 1'b1;
                                        fsm_display_ctrl_next_state = NEXT_FRAME;
                                    end                                    
                                end
            NEXT_FRAME      :   if(!enable) begin
                                    fsm_display_ctrl_next_state = IDLE;
                                end else begin                                  // memory handling can be added here
                                    line_start = 1'b1;
                                    fsm_display_ctrl_next_state = RUNNING;
                                end
                                
            default             fsm_display_ctrl_next_state = IDLE;
        endcase
    end : display_ctrl_comb

endmodule
