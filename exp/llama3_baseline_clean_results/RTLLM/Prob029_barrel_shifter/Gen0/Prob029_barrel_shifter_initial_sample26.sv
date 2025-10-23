module mux2X1(
    input  [7:0] a,
    input  [7:0] b,
    input        sel,
    output [7:0] out
);
    assign out = sel ? b : a;
endmodule

module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] shift4, shift2, shift1;

    // Shift by 4 positions
    assign shift4 = {in[3:0], in[7:4]};

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    mux2X1 stage1(
        .a(in),
        .b(shift4),
        .sel(ctrl[2]),
        .out(shift2)
    );

    // Shift by 2 positions
    assign shift1 = {shift2[6:0], shift2[7]};

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    mux2X1 stage2(
        .a(shift2),
        .b(shift1),
        .sel(ctrl[1]),
        .out(shift1)
    );

    // Shift by 1 position
    assign out = {shift1[6:0], shift1[7]};

    // Stage 3: Shift by 1 position if ctrl[0] is high
    mux2X1 stage3(
        .a(shift1),
        .b(out),
        .sel(ctrl[0]),
        .out(out)
    );
endmodule