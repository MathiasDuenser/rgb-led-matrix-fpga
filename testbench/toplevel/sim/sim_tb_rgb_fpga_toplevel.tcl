
echo Prepare Simulation:

echo -> Create working library
vlib work
vmap work 

# compile sources
vlog -lint ../../../src/*.sv

echo ----> Compile packages, etc.
vlog ../tb/tb_rgb_fpga_toplevel.sv

#log -r /*

vsim +nowarnTSCALE tb_rgb_fpga_toplevel

# log all vairables in the design
log -r /*

# run simulation
do ../wave/wave_tb_rgb_fpga_toplevel.do
run -all

# show wave window
view wave
wave zoomfull