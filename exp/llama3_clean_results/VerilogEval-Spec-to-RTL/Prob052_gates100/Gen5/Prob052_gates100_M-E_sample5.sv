module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire and_seg1, and_seg2, and_seg3, and_seg4;
    wire or_seg1, or_seg2, or_seg3, or_seg4;
    wire xor_seg1, xor_seg2, xor_seg3, xor_seg4;

    // Segment 1: in[24:0]
    and_or_xor_segment segment1(
        .in(in[24:0]),
        .out_and(and_seg1),
        .out_or(or_seg1),
        .out_xor(xor_seg1)
    );

    // Segment 2: in[49:25]
    and_or_xor_segment segment2(
        .in(in[49:25]),
        .out_and(and_seg2),
        .out_or(or_seg2),
        .out_xor(xor_seg2)
    );

    // Segment 3: in[74:50]
    and_or_xor_segment segment3(
        .in(in[74:50]),
        .out_and(and_seg3),
        .out_or(or_seg3),
        .out_xor(xor_seg3)
    );

    // Segment 4: in[99:75]
    and_or_xor_segment segment4(
        .in(in[99:75]),
        .out_and(and_seg4),
        .out_or(or_seg4),
        .out_xor(xor_seg4)
    );

    assign out_and = and_seg1 & and_seg2 & and_seg3 & and_seg4;
    assign out_or = or_seg1 | or_seg2 | or_seg3 | or_seg4;
    assign out_xor = xor_seg1 ^ xor_seg2 ^ xor_seg3 ^ xor_seg4;

endmodule

module and_or_xor_segment(
    input  [24:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;
    assign out_or = |in;
    assign out_xor = ^in;

endmodule