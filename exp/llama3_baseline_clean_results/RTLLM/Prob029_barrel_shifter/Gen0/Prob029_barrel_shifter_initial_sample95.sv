// Define the mux2X1 submodule
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = sel ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Internal wires for stages
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1_mux(in, {in[3:0], 4'b0000}, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux(stage1_out, {stage1_out[1:0], 6'b000000}, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3_mux(stage2_out, {stage2_out[6:0], stage2_out[7]}, ctrl[0], out);
endmodule