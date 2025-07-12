module mux2X1(
    input  wire [7:0] in0,
    input  wire [7:0] in1,
    input  wire       sel,
    output wire [7:0] out
);

    assign out = (sel) ? in1 : in0;

endmodule

module barrel_shifter(
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions
    mux2X1 shift4_mux(
        .in0(in),
        .in1({in[3:0], 4'b0000}),
        .sel(ctrl[2]),
        .out(shift4)
    );

    // Stage 2: Shift by 2 positions
    mux2X1 shift2_mux(
        .in0(shift4),
        .in1({shift4[5:0], 2'b00}),
        .sel(ctrl[1]),
        .out(shift2)
    );

    // Stage 3: Shift by 1 position
    mux2X1 shift1_mux(
        .in0(shift2),
        .in1({shift2[6:0], 1'b0}),
        .sel(ctrl[0]),
        .out(shift1)
    );

    assign out = shift1;

endmodule