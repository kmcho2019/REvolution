module EightBitCLAAdder (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout,
    output       carry_into_msb
);
    wire [7:0] p = a ^ b;        // propagate signals
    wire [7:0] g = a & b;        // generate signals

    // Carry signals (c[0] = cin)
    wire c1, c2, c3, c4, c5, c6, c7, c8;

    assign c1 = g[0] | (p[0] & cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign c4 = g[3] | (p[3] & c3);
    assign c5 = g[4] | (p[4] & c4);
    assign c6 = g[5] | (p[5] & c5);
    assign c7 = g[6] | (p[6] & c6);
    assign c8 = g[7] | (p[7] & c7);

    assign sum = p ^ {c7, c6, c5, c4, c3, c2, c1, cin};
    assign cout = c8;
    assign carry_into_msb = c7;

endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout, carry_into_msb;

    EightBitCLAAdder adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    assign overflow = carry_into_msb ^ cout;

endmodule