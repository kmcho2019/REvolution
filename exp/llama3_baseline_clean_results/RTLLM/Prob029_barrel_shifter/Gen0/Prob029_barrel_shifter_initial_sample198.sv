// Define the mux2X1 submodule
module mux2X1(
    input [7:0] a, b,  // Two 8-bit inputs
    input sel,         // Select signal
    output [7:0] out   // Output of the multiplexer
);

    assign out = sel? b : a;

endmodule

// Define the barrel shifter module
module barrel_shifter(
    input [7:0] in,     // 8-bit input to be shifted
    input [2:0] ctrl,  // 3-bit control signal
    output [7:0] out    // 8-bit shifted output
);

    // Wire declarations for intermediate results
    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 shift_by_4(
       .a(in), 
       .b({in[3:0], 4'b0000}),  // Shift input by 4 positions to the right
       .sel(ctrl[2]),
       .out(shift4)
    );

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 shift_by_2(
       .a(shift4), 
       .b({shift4[5:0], 2'b00}),  // Shift result by 2 positions to the right
       .sel(ctrl[1]),
       .out(shift2)
    );

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 shift_by_1(
       .a(shift2), 
       .b({shift2[6:0], 1'b0}),  // Shift result by 1 position to the right
       .sel(ctrl[0]),
       .out(out)
    );

endmodule