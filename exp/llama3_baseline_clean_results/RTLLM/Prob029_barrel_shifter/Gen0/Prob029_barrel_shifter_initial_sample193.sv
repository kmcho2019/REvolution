module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Define the mux2X1 submodule
module mux2X1(
    input [7:0] in0,
    input [7:0] in1,
    input sel,
    output [7:0] out
);
    assign out = sel ? in1 : in0;
endmodule

// Define the wires for the intermediate results
wire [7:0] shift4_out;
wire [7:0] shift2_out;
wire [7:0] shift1_out;

// Stage 1: Shift by 4 positions if ctrl[2] is high
mux2X1 shift4(
    .in0(in),
    .in1({in[3:0], 4'b0000}), // Shift in by 4 positions
    .sel(ctrl[2]),
    .out(shift4_out)
);

// Stage 2: Shift by 2 positions if ctrl[1] is high
mux2X1 shift2(
    .in0(shift4_out),
    .in1({shift4_out[5:0], 2'b00}), // Shift in by 2 positions
    .sel(ctrl[1]),
    .out(shift2_out)
);

// Stage 3: Shift by 1 position if ctrl[0] is high
mux2X1 shift1(
    .in0(shift2_out),
    .in1({shift2_out[6:0], 1'b0}), // Shift in by 1 position
    .sel(ctrl[0]),
    .out(shift1_out)
);

// Assign the final output
assign out = shift1_out;

endmodule