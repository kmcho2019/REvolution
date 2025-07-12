// Define the submodule mux2X1 for 2-to-1 multiplexing
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 mux1_0(in, {in[3:0], 4'b0000}, ctrl[2], stage1_out);
    mux2X1 mux1_1(in, {4'b0000, in[7:4]}, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 mux2_0(stage1_out, {stage1_out[5:0], 2'b00}, ctrl[1], stage2_out);
    mux2X1 mux2_1(stage1_out, {2'b00, stage1_out[7:2]}, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 mux3_0(stage2_out, {stage2_out[6:0], 1'b0}, ctrl[0], out);
    mux2X1 mux3_1(stage2_out, {1'b0, stage2_out[7:1]}, ctrl[0], out);
endmodule