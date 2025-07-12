// Define the mux2x1 module
module mux2x1(out, in0, in1, sel);
    output [7:0] out;
    input  [7:0] in0, in1;
    input         sel;

    assign out = sel ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(out, in, ctrl);
    output [7:0] out;
    input  [7:0] in;
    input  [2:0] ctrl;

    // Intermediate signals for each stage
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2x1 stage1_m1(stage1_out[7], in[7], in[3], ctrl[2]);
    mux2x1 stage1_m2(stage1_out[6], in[6], in[2], ctrl[2]);
    mux2x1 stage1_m3(stage1_out[5], in[5], in[1], ctrl[2]);
    mux2x1 stage1_m4(stage1_out[4], in[4], in[0], ctrl[2]);
    mux2x1 stage1_m5(stage1_out[3], in[3], in[7], ctrl[2]);
    mux2x1 stage1_m6(stage1_out[2], in[2], in[6], ctrl[2]);
    mux2x1 stage1_m7(stage1_out[1], in[1], in[5], ctrl[2]);
    mux2x1 stage1_m8(stage1_out[0], in[0], in[4], ctrl[2]);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2x1 stage2_m1(stage2_out[7], stage1_out[7], stage1_out[5], ctrl[1]);
    mux2x1 stage2_m2(stage2_out[6], stage1_out[6], stage1_out[4], ctrl[1]);
    mux2x1 stage2_m3(stage2_out[5], stage1_out[5], stage1_out[3], ctrl[1]);
    mux2x1 stage2_m4(stage2_out[4], stage1_out[4], stage1_out[2], ctrl[1]);
    mux2x1 stage2_m5(stage2_out[3], stage1_out[3], stage1_out[1], ctrl[1]);
    mux2x1 stage2_m6(stage2_out[2], stage1_out[2], stage1_out[0], ctrl[1]);
    mux2x1 stage2_m7(stage2_out[1], stage1_out[1], stage1_out[7], ctrl[1]);
    mux2x1 stage2_m8(stage2_out[0], stage1_out[0], stage1_out[6], ctrl[1]);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2x1 stage3_m1(out[7], stage2_out[7], stage2_out[6], ctrl[0]);
    mux2x1 stage3_m2(out[6], stage2_out[6], stage2_out[5], ctrl[0]);
    mux2x1 stage3_m3(out[5], stage2_out[5], stage2_out[4], ctrl[0]);
    mux2x1 stage3_m4(out[4], stage2_out[4], stage2_out[3], ctrl[0]);
    mux2x1 stage3_m5(out[3], stage2_out[3], stage2_out[2], ctrl[0]);
    mux2x1 stage3_m6(out[2], stage2_out[2], stage2_out[1], ctrl[0]);
    mux2x1 stage3_m7(out[1], stage2_out[1], stage2_out[0], ctrl[0]);
    mux2x1 stage3_m8(out[0], stage2_out[0], stage2_out[7], ctrl[0]);
endmodule