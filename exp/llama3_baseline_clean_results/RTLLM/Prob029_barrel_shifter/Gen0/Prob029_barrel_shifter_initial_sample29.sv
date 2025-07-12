// Submodule for 2-to-1 multiplexer
module mux2X1(
    input  [7:0] in0,  // First input
    input  [7:0] in1,  // Second input
    input         sel, // Select signal
    output [7:0] out   // Output
);

    assign out = sel? in1 : in0;

endmodule

// Barrel shifter module
module barrel_shifter(
    input  [7:0] in,   // 8-bit input to be shifted
    input  [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Intermediate signals
    wire [7:0] shift_4;
    wire [7:0] shift_2;
    wire [7:0] shift_1;

    // Shift by 4 positions
    assign shift_4 = {in[3:0], 4'b0000};

    // Shift by 2 positions
    assign shift_2 = {in[5:0], 2'b00};

    // Shift by 1 position
    assign shift_1 = {in[6:0], 1'b0};

    // First stage of multiplexers (shift by 4)
    mux2X1 mux_4(
       .in0(in),    // Original input
       .in1(shift_4), // Input shifted by 4
       .sel(ctrl[2]), // Select signal from ctrl[2]
       .out(shift_4)  // Output of this stage
    );

    // Second stage of multiplexers (shift by 2)
    mux2X1 mux_2(
       .in0(shift_4), // Input from previous stage
       .in1(shift_2), // Input shifted by 2
       .sel(ctrl[1]), // Select signal from ctrl[1]
       .out(shift_2)  // Output of this stage
    );

    // Third stage of multiplexers (shift by 1)
    mux2X1 mux_1(
       .in0(shift_2), // Input from previous stage
       .in1(shift_1), // Input shifted by 1
       .sel(ctrl[0]), // Select signal from ctrl[0]
       .out(out)      // Final output
    );

endmodule