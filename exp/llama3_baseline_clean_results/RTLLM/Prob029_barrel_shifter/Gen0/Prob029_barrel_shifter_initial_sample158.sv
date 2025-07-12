// Define the 2-to-1 multiplexer submodule
module mux2X1(
    input [7:0] a,
    input [7:0] b,
    input sel,
    output [7:0] out
);
    assign out = (sel) ? b : a;
endmodule

// Define the barrel shifter module
module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    wire [7:0] stage1_shifted;
    wire [7:0] stage2_shifted;
    wire [7:0] stage3_shifted;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    assign stage1_shifted = {in[3:0], 4'b0000};
    mux2X1 stage1_mux(in, stage1_shifted, ctrl[2], stage1_out);

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    assign stage2_shifted = {in[6:0], 2'b00};
    mux2X1 stage2_mux(stage1_out, stage2_shifted, ctrl[1], stage2_out);

    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign stage3_shifted = {in[7:1], 1'b0};
    mux2X1 stage3_mux(stage2_out, stage3_shifted, ctrl[0], out);
endmodule