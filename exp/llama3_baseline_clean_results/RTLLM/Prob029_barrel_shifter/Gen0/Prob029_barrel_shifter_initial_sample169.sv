// Define a 2-to-1 multiplexer submodule
module mux2X1(
    input [7:0] in0, in1,  // Two 8-bit inputs
    input sel,          // Select signal
    output [7:0] out    // Output of the multiplexer
);
    assign out = sel ? in1 : in0;
endmodule

// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,     // 8-bit input
    input [2:0] ctrl,  // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Intermediate wires to hold shifted values
    wire [7:0] shift4;
    wire [7:0] shift2;
    wire [7:0] shift1;

    // Perform shift by 4 positions if ctrl[2] is high
    mux2X1 mux_shift4(
        .in0(in),            // Original input
        .in1({in[3:0], 4'b0}), // Input shifted by 4 positions
        .sel(ctrl[2]),
        .out(shift4)
    );

    // Perform shift by 2 positions if ctrl[1] is high
    mux2X1 mux_shift2(
        .in0(shift4),          // Output from previous stage
        .in1({shift4[5:0], 2'b0}), // Shifted by 2 positions
        .sel(ctrl[1]),
        .out(shift2)
    );

    // Perform shift by 1 position if ctrl[0] is high
    mux2X1 mux_shift1(
        .in0(shift2),          // Output from previous stage
        .in1({shift2[6:0], 1'b0}), // Shifted by 1 position
        .sel(ctrl[0]),
        .out(out)
    );
endmodule