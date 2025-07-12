// 2-to-1 Multiplexer submodule
module mux2X1(
    input  sel,
    input  [7:0] in0,
    input  [7:0] in1,
    output [7:0] out
);

    assign out = (sel) ? in1 : in0;

endmodule

// Barrel Shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    wire [7:0] shift4;
    wire [7:0] shift2;
    wire [7:0] shift1;

    // Stage 1: Shift by 4 positions
    mux2X1 mux_shift4(
        .sel(ctrl[2]),
        .in0(in),
        .in1({in[3:0], 4'b0000}), // Shift in by 4 positions
        .out(shift4)
    );

    // Stage 2: Shift by 2 positions
    mux2X1 mux_shift2(
        .sel(ctrl[1]),
        .in0(shift4),
        .in1({shift4[5:0], 2'b00}), // Shift in by 2 positions
        .out(shift2)
    );

    // Stage 3: Shift by 1 position
    mux2X1 mux_shift1(
        .sel(ctrl[0]),
        .in0(shift2),
        .in1({shift2[6:0], 1'b0}), // Shift in by 1 position
        .out(shift1)
    );

    assign out = shift1;

endmodule