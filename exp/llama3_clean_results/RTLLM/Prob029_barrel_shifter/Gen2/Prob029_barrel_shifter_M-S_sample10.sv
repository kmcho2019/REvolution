// Define the mux2X1 submodule
module mux2X1(
    input [7:0] in0,  // First 8-bit input
    input [7:0] in1,  // Second 8-bit input
    input sel,        // Select signal
    output [7:0] out  // 8-bit output
);
    assign out = sel? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);
    // First stage: Shift by 4 positions if ctrl[2] is high
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(in, {in[3:0], 4'b0000}, ctrl[2], stage1_out);

    // Second stage: Shift by 2 positions if ctrl[1] is high
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(stage1_out, {stage1_out[5:0], 2'b00}, ctrl[1], stage2_out);

    // Third stage: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3_mux(stage2_out, {stage2_out[6:0], 1'b0}, ctrl[0], out);

endmodule