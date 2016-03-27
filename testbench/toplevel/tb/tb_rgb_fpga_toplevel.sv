//****************************************************************************
// X-1 (http://x-1.at)
//
// Project:     RGB LED Matrix
// Module:      Testbench
// Author:      Mathias Duenser (MaDu)
//
// ChangeLog:
//  V01 MaDu 23.03.2016
//      -- Initial Release
//****************************************************************************

`timescale 100ps/100ps

module tb_rgb_fpga_toplevel ();

    // ---------------- INPUT PORT DECLARATIONS --------------------
    /* input */ logic           rst_n;      // asynchronous reset (active low)
    /* input */ logic           clk;        // system clock
    /* input */ logic           enable;
    // ---------------- OUTPUT PORT DECLARATIONS -------------------
    /* output */ logic          matrix_r0;  // r0 line (red #0)
    /* output */ logic          matrix_g0;  // matrix g0 line (green #0)
    /* output */ logic          matrix_b0;  // matrix b0 line (blue #0)
    /* output */ logic          matrix_r1;  // matrix r0 line (red #1)
    /* output */ logic          matrix_g1;  // matrix g0 line (green #1)
    /* output */ logic          matrix_b1;  // matrix b0 line (blue #1)
    /* output */ logic          matrix_clk; // matrix clock line
    /* output */ logic          matrix_oe;  // matrix output enable line
    /* output */ logic          matrix_lat; // matrix latch line
    /* output */ logic [3:0]    matrix_addr; // matrix line address (sometimes A,B,C,D)
    
    // ---- DUT instance ----------------------------
    rgb_fpga_toplevel o_rgb_fpga_toplevel(.*);
    
    // ---- test pattern ----------------------------
    logic   run_sim = 1'b1;     // defines run mode of simulation
    string  simtxt;             // simulation comments
    integer test_nr = 0;        // test counter
    integer error_cnt = 0;      // error counter

    // ---- single sequence -------------------------
    initial begin : stimuli
        $display("-------------------------------------------");
        $display("tb_rgb_fpga_toplevel.sv");
        $display("-------------------------------------------");
        
        // ---- INIT ------------------------------------
        simtxt = "init simulation (RESET)"; $display("%s",simtxt);  
        init_inputs_to_zero();      // set all inputs to zero
        #10us;
        @(negedge clk) 
            rst_n = 1'b1;
        #10us
        @(negedge clk) 
            enable = 1'b1;
                 
        @(posedge o_rgb_fpga_toplevel.frame_rdy)
        @(posedge o_rgb_fpga_toplevel.frame_rdy)
        @(negedge clk)    
        enable = 1'b0;
        
        #500us;
                
        if (error_cnt > 0) begin
            $display("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
            $display("FAIL: tb_rgb_fpga_toplevel.sv completed with %3d fails",error_cnt);
            $display("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        end
        else begin
            $display("------------------------------------------");
            $display("PASS: tb_rgb_fpga_toplevel.sv w/o fails.");
            $display("------------------------------------------");
        end
        run_sim = 1'b0;
    end
    
    // ----------------------------------------------------------------------
    // assertions
    // ----------------------------------------------------------------------
    
    // ----------------------------------------------------------------------
    // periodic signals & generators
    // ----------------------------------------------------------------------
    
    initial begin : clk_gen_40m
        clk = 1'b0;
        while(run_sim) begin
            #125    clk = !clk;
        end //while
    end : clk_gen_40m
    
    // ----------------------------------------------------------------------
    // tasks
    // ----------------------------------------------------------------------

    // set all inputs of llc_error to zero
    task init_inputs_to_zero();
        rst_n = 1'd0;
        enable = 1'd0;
        // clk -> generator
    endtask
    
endmodule