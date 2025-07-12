// Define the mux2X1 submodule
module mux2X1(
    input [7:0] in0, // First 8-bit input
    input [7:0] in1, // Second 8-bit input
    input sel, // 1-bit select signal
    output [7:0] out // 8-bit output
);

    // Use the ternary operator to select between in0 and in1 based on sel
    assign out = (sel) ? in1 : in0;

endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in, // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out // 8-bit shifted output
);

    // Declare wire signals for intermediate results
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    wire [7:0] stage3_out;

    // First stage: shift by 4 positions if ctrl[2] is high
    mux2X1 stage1_mux(
        .in0(in), // Original input
        .in1(in << 4), // Input shifted by 4 positions
        .sel(ctrl[2]), // Select signal
        .out(stage1_out) // Intermediate result
    );

    // Second stage: shift by 2 positions if ctrl[1] is high
    mux2X1 stage2_mux(
        .in0(stage1_out), // Intermediate result from stage 1
        .in1(stage1_out << 2), // Intermediate result shifted by 2 positions
        .sel(ctrl[1]), // Select signal
        .out(stage2_out) // Intermediate result
    );

    // Third stage: shift by 1 position if ctrl[0] is high
    mux2X1 stage3_mux(
        .in0(stage2_out), // Intermediate result from stage 2
        .in1(stage2_out << 1), // Intermediate result shifted by 1 position
        .sel(ctrl[0]), // Select signal
        .out(stage3_out) // Final output
    );

    // Assign the final output to the out port
    assign out = stage3_out;

endmodule