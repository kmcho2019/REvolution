module mux2X1(in0, in1, sel, out);
    input [7:0] in0, in1;
    input sel;
    output [7:0] out;

    assign out = sel ? in1 : in0;
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] stage1_out, stage2_out;

    // Shift by 4 positions based on ctrl[2]
    mux2X1 in, {in[3:0], 4'b0000}, ctrl[2], stage1_out;

    // Shift by 2 positions based on ctrl[1]
    mux2X1 stage1_out, {stage1_out[5:0], 2'b00}, ctrl[1], stage2_out;

    // Shift by 1 position based on ctrl[0]
    mux2X1 stage2_out, {stage2_out[6:0], 1'b0}, ctrl[0], out;
endmodule