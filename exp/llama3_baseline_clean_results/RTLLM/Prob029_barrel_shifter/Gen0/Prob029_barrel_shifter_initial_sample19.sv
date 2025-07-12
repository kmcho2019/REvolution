// Define the mux2X1 submodule
module mux2X1(a, b, sel, out);
    input [7:0] a;
    input [7:0] b;
    input sel;
    output [7:0] out;

    assign out = (sel) ? b : a;
endmodule

// Define the barrel_shifter module
module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    wire [7:0] stage1_in = {in[3:0], 4'b0000};  // Shift in by 4 positions
    mux2X1 in, stage1_in, ctrl[2], stage1_out;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    wire [7:0] stage2_in = {stage1_out[5:0], 2'b00};  // Shift in by 2 positions
    mux2X1 stage1_out, stage2_in, ctrl[1], stage2_out;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    wire [7:0] stage3_out;
    wire [7:0] stage3_in = {stage2_out[6:0], 1'b0};  // Shift in by 1 position
    mux2X1 stage2_out, stage3_in, ctrl[0], stage3_out;

    assign out = stage3_out;
endmodule