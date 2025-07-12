module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

// Define the 2-to-1 multiplexer submodule
module mux2X1(
    input  [7:0] a,
    input  [7:0] b,
    input        sel,
    output [7:0] out
);
    assign out = (sel) ? b : a;
endmodule

// Define the wiring for the barrel shifter
wire [7:0] shift4, shift2, shift1;

// Stage 1: Shift by 4 positions if ctrl[2] is high
mux2X1 mux_shift4(
    .a(in),
    .b({in[3:0], 4'b0000}), // Shift in by 4 positions
    .sel(ctrl[2]),
    .out(shift4)
);

// Stage 2: Shift by 2 positions if ctrl[1] is high
mux2X1 mux_shift2(
    .a(shift4),
    .b({shift4[5:0], 2'b00}), // Shift in by 2 positions
    .sel(ctrl[1]),
    .out(shift2)
);

// Stage 3: Shift by 1 position if ctrl[0] is high
mux2X1 mux_shift1(
    .a(shift2),
    .b({shift2[6:0], 1'b0}), // Shift in by 1 position
    .sel(ctrl[0]),
    .out(shift1)
);

// Assign the final output
assign out = shift1;

endmodule