module mux2X1(a, b, sel, out);
    input [7:0] a;
    input [7:0] b;
    input sel;
    output [7:0] out;

    assign out = sel ? b : a;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1mux0(in, {in[3:0], 4'b0000}, ctrl[2], stage1_out[0]);
    mux2X1 stage1mux1(in, {in[2:0], 4'b0000, in[7]}, ctrl[2], stage1_out[1]);
    mux2X1 stage1mux2(in, {in[1:0], 4'b0000, in[7:2]}, ctrl[2], stage1_out[2]);
    mux2X1 stage1mux3(in, {in[0], 4'b0000, in[7:1]}, ctrl[2], stage1_out[3]);
    mux2X1 stage1mux4(in, {4'b0000, in[7:4]}, ctrl[2], stage1_out[4]);
    mux2X1 stage1mux5(in, {4'b0000, in[7:3], in[7]}, ctrl[2], stage1_out[5]);
    mux2X1 stage1mux6(in, {4'b0000, in[7:2], in[7:1]}, ctrl[2], stage1_out[6]);
    mux2X1 stage1mux7(in, {4'b0000, in[7:1], in[7:0]}, ctrl[2], stage1_out[7]);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2mux0(stage1_out, {stage1_out[6:0], 2'b00}, ctrl[1], stage2_out[0]);
    mux2X1 stage2mux1(stage1_out, {stage1_out[5:0], 2'b00, stage1_out[7]}, ctrl[1], stage2_out[1]);
    mux2X1 stage2mux2(stage1_out, {stage1_out[4:0], 2'b00, stage1_out[7:1]}, ctrl[1], stage2_out[2]);
    mux2X1 stage2mux3(stage1_out, {stage1_out[3:0], 2'b00, stage1_out[7:2]}, ctrl[1], stage2_out[3]);
    mux2X1 stage2mux4(stage1_out, {2'b00, stage1_out[7:4]}, ctrl[1], stage2_out[4]);
    mux2X1 stage2mux5(stage1_out, {2'b00, stage1_out[7:3], stage1_out[7]}, ctrl[1], stage2_out[5]);
    mux2X1 stage2mux6(stage1_out, {2'b00, stage1_out[7:2], stage1_out[7:1]}, ctrl[1], stage2_out[6]);
    mux2X1 stage2mux7(stage1_out, {2'b00, stage1_out[7:1], stage1_out[7:0]}, ctrl[1], stage2_out[7]);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3mux0(stage2_out, {stage2_out[7:1], 1'b0}, ctrl[0], out[0]);
    mux2X1 stage3mux1(stage2_out, {stage2_out[7:1], stage2_out[0]}, ctrl[0], out[1]);
    mux2X1 stage3mux2(stage2_out, {stage2_out[7:0], stage2_out[1]}, ctrl[0], out[2]);
    mux2X1 stage3mux3(stage2_out, {stage2_out[7:0], stage2_out[2]}, ctrl[0], out[3]);
    mux2X1 stage3mux4(stage2_out, {stage2_out[6:0], stage2_out[7]}, ctrl[0], out[4]);
    mux2X1 stage3mux5(stage2_out, {stage2_out[6:0], stage2_out[7]}, ctrl[0], out[5]);
    mux2X1 stage3mux6(stage2_out, {stage2_out[5:0], stage2_out[7]}, ctrl[0], out[6]);
    mux2X1 stage3mux7(stage2_out, {stage2_out[5:0], stage2_out[7]}, ctrl[0], out[7]);
endmodule