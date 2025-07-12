// Define the mux2X1 submodule
module mux2X1(
    input  [7:0] in0,  // First 8-bit input
    input  [7:0] in1,  // Second 8-bit input
    input        sel,  // Select signal
    output [7:0] out   // Selected 8-bit output
);

    assign out = sel? in1 : in0;

endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input  [7:0] in,   // 8-bit input to be shifted
    input  [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Intermediate wires for shifted inputs
    wire [7:0] shift4;
    wire [7:0] shift2;
    wire [7:0] shift1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    assign shift4 = {in[3:0], 4'b0000};

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    assign shift2 = ctrl[1]? {in[5:0], 2'b00} : in;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign shift1 = ctrl[0]? {in[6:0], 1'b0} : in;

    // Use mux2X1 submodules to select between shifted inputs
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    wire [7:0] stage3_out;

    mux2X1 stage1_mux(in, shift4, ctrl[2], stage1_out);
    mux2X1 stage2_mux(stage1_out, shift2, ctrl[1], stage2_out);
    mux2X1 stage3_mux(stage2_out, shift1, ctrl[0], stage3_out);

    // Final output
    assign out = stage3_out;

endmodule