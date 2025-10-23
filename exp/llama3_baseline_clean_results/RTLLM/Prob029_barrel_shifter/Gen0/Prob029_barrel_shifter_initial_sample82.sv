// Define the mux2X1 submodule
module mux2X1(a, b, sel, out);
    input [7:0] a, b;
    input sel;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Define the intermediate signals for each stage
    wire [7:0] stage1_out, stage2_out, stage3_out;

    // Stage 1: Shift by 4 positions
    mux2X1 u1(in, {in[3:0], 4'b0000}, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions
    mux2X1 u2(stage1_out, {stage1_out[5:0], 2'b00}, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position
    mux2X1 u3(stage2_out, {stage2_out[6:0], 1'b0}, ctrl[0], stage3_out);

    // Assign the final output
    assign out = stage3_out;
endmodule