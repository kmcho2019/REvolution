module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions
    wire [7:0] stage1_shifted, stage1_out;
    assign stage1_shifted = {in[3:0], 4'b0000};
    mux2X1 u1(in, stage1_shifted, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions
    wire [7:0] stage2_shifted, stage2_out;
    assign stage2_shifted = {stage1_out[5:0], 2'b00};
    mux2X1 u2(stage1_out, stage2_shifted, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position
    wire [7:0] stage3_shifted;
    assign stage3_shifted = {stage2_out[6:0], 1'b0};
    mux2X1 u3(stage2_out, stage3_shifted, ctrl[0], out);
endmodule