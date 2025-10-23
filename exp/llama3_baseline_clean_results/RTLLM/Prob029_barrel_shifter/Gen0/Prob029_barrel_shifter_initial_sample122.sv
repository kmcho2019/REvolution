// Define the 2-to-1 multiplexer submodule
module mux2X1(sel, a, b, out);
    input sel;
    input [7:0] a, b;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Intermediate wires for each stage
    wire [7:0] stage1_out, stage2_out;

    // Stage 1: Shift by 4 positions based on ctrl[2]
    mux2X1 stage1_mux(ctrl[2], in, {in[3:0], 4'b0000}, stage1_out);

    // Stage 2: Shift by 2 positions based on ctrl[1]
    mux2X1 stage2_mux(ctrl[1], stage1_out, {stage1_out[5:0], 2'b00}, stage2_out);

    // Stage 3: Shift by 1 position based on ctrl[0]
    mux2X1 stage3_mux(ctrl[0], stage2_out, {stage2_out[6:0], 1'b0}, out);
endmodule