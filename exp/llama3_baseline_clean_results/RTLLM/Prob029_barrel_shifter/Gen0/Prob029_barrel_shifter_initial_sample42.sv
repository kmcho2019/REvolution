// Define the mux2X1 submodule
module mux2X1(
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// Define the barrel shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Stage 1: Shift by 4 positions based on ctrl[2]
    wire [7:0] stage1_out;
    mux2X1 stage1_mux0(ctrl[2], in[0], in[4], stage1_out[0]);
    mux2X1 stage1_mux1(ctrl[2], in[1], in[5], stage1_out[1]);
    mux2X1 stage1_mux2(ctrl[2], in[2], in[6], stage1_out[2]);
    mux2X1 stage1_mux3(ctrl[2], in[3], in[7], stage1_out[3]);
    mux2X1 stage1_mux4(ctrl[2], in[4], in[0], stage1_out[4]);
    mux2X1 stage1_mux5(ctrl[2], in[5], in[1], stage1_out[5]);
    mux2X1 stage1_mux6(ctrl[2], in[6], in[2], stage1_out[6]);
    mux2X1 stage1_mux7(ctrl[2], in[7], in[3], stage1_out[7]);

    // Stage 2: Shift by 2 positions based on ctrl[1]
    wire [7:0] stage2_out;
    mux2X1 stage2_mux0(ctrl[1], stage1_out[0], stage1_out[2], stage2_out[0]);
    mux2X1 stage2_mux1(ctrl[1], stage1_out[1], stage1_out[3], stage2_out[1]);
    mux2X1 stage2_mux2(ctrl[1], stage1_out[2], stage1_out[4], stage2_out[2]);
    mux2X1 stage2_mux3(ctrl[1], stage1_out[3], stage1_out[5], stage2_out[3]);
    mux2X1 stage2_mux4(ctrl[1], stage1_out[4], stage1_out[6], stage2_out[4]);
    mux2X1 stage2_mux5(ctrl[1], stage1_out[5], stage1_out[7], stage2_out[5]);
    mux2X1 stage2_mux6(ctrl[1], stage1_out[6], stage1_out[0], stage2_out[6]);
    mux2X1 stage2_mux7(ctrl[1], stage1_out[7], stage1_out[1], stage2_out[7]);

    // Stage 3: Shift by 1 position based on ctrl[0]
    mux2X1 stage3_mux0(ctrl[0], stage2_out[0], stage2_out[1], out[0]);
    mux2X1 stage3_mux1(ctrl[0], stage2_out[1], stage2_out[2], out[1]);
    mux2X1 stage3_mux2(ctrl[0], stage2_out[2], stage2_out[3], out[2]);
    mux2X1 stage3_mux3(ctrl[0], stage2_out[3], stage2_out[4], out[3]);
    mux2X1 stage3_mux4(ctrl[0], stage2_out[4], stage2_out[5], out[4]);
    mux2X1 stage3_mux5(ctrl[0], stage2_out[5], stage2_out[6], out[5]);
    mux2X1 stage3_mux6(ctrl[0], stage2_out[6], stage2_out[7], out[6]);
    mux2X1 stage3_mux7(ctrl[0], stage2_out[7], stage2_out[0], out[7]);
endmodule