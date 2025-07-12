// Define the mux2X1 submodule
module mux2X1(
    input [7:0] in0,  // First input
    input [7:0] in1,  // Second input
    input       sel,  // Select signal
    output [7:0] out   // Output
);

    // Use a conditional statement to select between in0 and in1 based on sel
    assign out = (sel) ? in1 : in0;

endmodule

// Define the barrel shifter module
module barrel_shifter(
    input  [7:0] in,   // 8-bit input
    input  [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Define internal wires
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1(
        .in0(in),            // Original input
        .in1({in[3:0], 4'b0000}), // Input shifted by 4 positions
        .sel(ctrl[2]),       // Select signal (ctrl[2])
        .out(stage1_out)     // Output of this stage
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2(
        .in0(stage1_out),    // Output of previous stage
        .in1({stage1_out[5:0], 2'b00}), // Output shifted by 2 positions
        .sel(ctrl[1]),       // Select signal (ctrl[1])
        .out(stage2_out)     // Output of this stage
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3(
        .in0(stage2_out),    // Output of previous stage
        .in1({stage2_out[6:0], 1'b0}), // Output shifted by 1 position
        .sel(ctrl[0]),       // Select signal (ctrl[0])
        .out(out)            // Final output
    );

endmodule