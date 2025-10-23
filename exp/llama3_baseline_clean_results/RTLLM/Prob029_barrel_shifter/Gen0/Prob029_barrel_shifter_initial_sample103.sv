// Define a 2-to-1 multiplexer submodule
module mux2X1(
    input  [7:0] in0,  // First input
    input  [7:0] in1,  // Second input
    input        sel,  // Select signal
    output [7:0] out   // Output
);

    assign out = sel ? in1 : in0;

endmodule

// Define the barrel shifter module
module barrel_shifter(
    input  [7:0] in,   // 8-bit input
    input  [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Intermediate wires to hold the output of each stage
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Stage 1: Shift by 4 positions based on ctrl[2]
    mux2X1 stage1_mux(
        .in0(in),  // Original input
        .in1({in[3:0], 4'b0000}),  // Input shifted by 4 positions
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: Shift by 2 positions based on ctrl[1]
    mux2X1 stage2_mux(
        .in0(stage1_out),  // Output from Stage 1
        .in1({stage1_out[5:0], 2'b00}),  // Stage 1 output shifted by 2 positions
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: Shift by 1 position based on ctrl[0]
    mux2X1 stage3_mux(
        .in0(stage2_out),  // Output from Stage 2
        .in1({stage2_out[6:0], 1'b0}),  // Stage 2 output shifted by 1 position
        .sel(ctrl[0]),
        .out(out)
    );

endmodule