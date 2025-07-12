module mux2X1(sel, in0, in1, out);
    input sel;
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = (sel) ? in1 : in0;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate wires
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions
    mux2X1 mux1(ctrl[2], in, {in[3:0], in[7:4]}, stage1_out);

    // Stage 2: Shift by 2 positions
    mux2X1 mux2(ctrl[1], stage1_out, {stage1_out[5:0], stage1_out[7:6]}, stage2_out);

    // Stage 3: Shift by 1 position
    mux2X1 mux3(ctrl[0], stage2_out, {stage2_out[6:0], stage2_out[7]}, out);
endmodule