module mux2X1(sel, in0, in1, out);
    input sel, in0, in1;
    output out;

    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Shift by 4 positions
    mux2X1 mux0_stage1(ctrl[2], in[0], in[4], stage1_out[0]);
    mux2X1 mux1_stage1(ctrl[2], in[1], in[5], stage1_out[1]);
    mux2X1 mux2_stage1(ctrl[2], in[2], in[6], stage1_out[2]);
    mux2X1 mux3_stage1(ctrl[2], in[3], in[7], stage1_out[3]);
    mux2X1 mux4_stage1(ctrl[2], in[4], in[0], stage1_out[4]);
    mux2X1 mux5_stage1(ctrl[2], in[5], in[1], stage1_out[5]);
    mux2X1 mux6_stage1(ctrl[2], in[6], in[2], stage1_out[6]);
    mux2X1 mux7_stage1(ctrl[2], in[7], in[3], stage1_out[7]);

    // Shift by 2 positions
    mux2X1 mux0_stage2(ctrl[1], stage1_out[0], stage1_out[2], stage2_out[0]);
    mux2X1 mux1_stage2(ctrl[1], stage1_out[1], stage1_out[3], stage2_out[1]);
    mux2X1 mux2_stage2(ctrl[1], stage1_out[2], stage1_out[4], stage2_out[2]);
    mux2X1 mux3_stage2(ctrl[1], stage1_out[3], stage1_out[5], stage2_out[3]);
    mux2X1 mux4_stage2(ctrl[1], stage1_out[4], stage1_out[6], stage2_out[4]);
    mux2X1 mux5_stage2(ctrl[1], stage1_out[5], stage1_out[7], stage2_out[5]);
    mux2X1 mux6_stage2(ctrl[1], stage1_out[6], stage1_out[0], stage2_out[6]);
    mux2X1 mux7_stage2(ctrl[1], stage1_out[7], stage1_out[1], stage2_out[7]);

    // Shift by 1 position
    mux2X1 mux0_stage3(ctrl[0], stage2_out[0], stage2_out[1], out[0]);
    mux2X1 mux1_stage3(ctrl[0], stage2_out[1], stage2_out[2], out[1]);
    mux2X1 mux2_stage3(ctrl[0], stage2_out[2], stage2_out[3], out[2]);
    mux2X1 mux3_stage3(ctrl[0], stage2_out[3], stage2_out[4], out[3]);
    mux2X1 mux4_stage3(ctrl[0], stage2_out[4], stage2_out[5], out[4]);
    mux2X1 mux5_stage3(ctrl[0], stage2_out[5], stage2_out[6], out[5]);
    mux2X1 mux6_stage3(ctrl[0], stage2_out[6], stage2_out[7], out[6]);
    mux2X1 mux7_stage3(ctrl[0], stage2_out[7], stage2_out[0], out[7]);
endmodule