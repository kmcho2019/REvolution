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

    // Calculate the shifted output
    wire [7:0] shift4, shift2, shift1;
    assign shift4 = {in[3:0], 4'b0000}; // Shift in by 4 positions
    assign shift2 = {in[5:0], 2'b00}; // Shift in by 2 positions
    assign shift1 = {in[6:0], 1'b0}; // Shift in by 1 position

    // Use a single stage with multiple 2-to-1 multiplexers
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(in, shift4, ctrl[2], stage1_out);

    wire [7:0] stage2_out;
    mux2X1 stage2_mux(stage1_out, shift2, ctrl[1], stage2_out);

    mux2X1 stage3_mux(stage2_out, shift1, ctrl[0], out);

endmodule