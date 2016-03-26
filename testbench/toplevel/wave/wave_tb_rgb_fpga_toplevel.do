onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Testbench
add wave -noupdate /tb_rgb_fpga_toplevel/run_sim
add wave -noupdate /tb_rgb_fpga_toplevel/test_nr
add wave -noupdate /tb_rgb_fpga_toplevel/error_cnt
add wave -noupdate -divider Inputs
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/rst_n
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/clk
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/enable
add wave -noupdate -divider Outputs
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_r0
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_g0
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_b0
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_r1
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_g1
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_b1
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_clk
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_oe
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_lat
add wave -noupdate -radix unsigned /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/matrix_addr
add wave -noupdate -divider Internal
add wave -noupdate -radix unsigned /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/o_rgb_fpga_line_red_0/col_cnt
add wave -noupdate -radix unsigned /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/o_rgb_fpga_line_red_0/pwm_cnt
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/line_rdy
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/o_rgb_fpga_line_red_0/line_start
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/frame_rdy
add wave -noupdate /tb_rgb_fpga_toplevel/o_rgb_fpga_toplevel/o_rgp_fpga_display_ctrl/fsm_display_ctrl_current_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 538
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {1898905600 ps}
