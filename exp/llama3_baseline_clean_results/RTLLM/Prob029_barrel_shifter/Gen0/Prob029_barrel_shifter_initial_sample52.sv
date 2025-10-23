// Define the mux2X1 submodule
module mux2X1(
    input  logic in0,
    input  logic in1,
    input  logic sel,
    output logic out
);

    assign out = sel ? in1 : in0;

endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input  logic [7:0] in,
    input  logic [2:0] ctrl,
    output logic [7:0] out
);

    // Stage 1: Shift by 4 positions (controlled by ctrl[2])
    logic [7:0] stage1_out;
    mux2X1 mux1_0(in[0], in[4], ctrl[2], stage1_out[0]);
    mux2X1 mux1_1(in[1], in[5], ctrl[2], stage1_out[1]);
    mux2X1 mux1_2(in[2], in[6], ctrl[2], stage1_out[2]);
    mux2X1 mux1_3(in[3], in[7], ctrl[2], stage1_out[3]);
    mux2X1 mux1_4(in[4], in[0], ctrl[2], stage1_out[4]);
    mux2X1 mux1_5(in[5], in[1], ctrl[2], stage1_out[5]);
    mux2X1 mux1_6(in[6], in[2], ctrl[2], stage1_out[6]);
    mux2X1 mux1_7(in[7], in[3], ctrl[2], stage1_out[7]);

    // Stage 2: Shift by 2 positions (controlled by ctrl[1])
    logic [7:0] stage2_out;
    mux2X1 mux2_0(stage1_out[0], stage1_out[2], ctrl[1], stage2_out[0]);
    mux2X1 mux2_1(stage1_out[1], stage1_out[3], ctrl[1], stage2_out[1]);
    mux2X1 mux2_2(stage1_out[2], stage1_out[4], ctrl[1], stage2_out[2]);
    mux2X1 mux2_3(stage1_out[3], stage1_out[5], ctrl[1], stage2_out[3]);
    mux2X1 mux2_4(stage1_out[4], stage1_out[6], ctrl[1], stage2_out[4]);
    mux2X1 mux2_5(stage1_out[5], stage1_out[7], ctrl[1], stage2_out[5]);
    mux2X1 mux2_6(stage1_out[6], stage1_out[0], ctrl[1], stage2_out[6]);
    mux2X1 mux2_7(stage1_out[7], stage1_out[1], ctrl[1], stage2_out[7]);

    // Stage 3: Shift by 1 position (controlled by ctrl[0])
    mux2X1 mux3_0(stage2_out[0], stage2_out[1], ctrl[0], out[0]);
    mux2X1 mux3_1(stage2_out[1], stage2_out[2], ctrl[0], out[1]);
    mux2X1 mux3_2(stage2_out[2], stage2_out[3], ctrl[0], out[2]);
    mux2X1 mux3_3(stage2_out[3], stage2_out[4], ctrl[0], out[3]);
    mux2X1 mux3_4(stage2_out[4], stage2_out[5], ctrl[0], out[4]);
    mux2X1 mux3_5(stage2_out[5], stage2_out[6], ctrl[0], out[5]);
    mux2X1 mux3_6(stage2_out[6], stage2_out[7], ctrl[0], out[6]);
    mux2X1 mux3_7(stage2_out[7], stage2_out[0], ctrl[0], out[7]);

endmodule