module FixedWidthCLAAdder8 (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout,
    output       carry_into_msb
);
    // Propagate and generate signals
    wire [7:0] p = a ^ b;
    wire [7:0] g = a & b;
    // Carry signals c[0] to c[8]: c[0] is cin, c[8] is final cout
    wire [8:0] c;

    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    assign sum = p ^ c[7:0];
    assign cout = c[8];
    assign carry_into_msb = c[7];

endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout;
    wire carry_into_msb;

    FixedWidthCLAAdder8 cla_adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    // Overflow occurs if carry into MSB differs from carry out of MSB
    assign overflow = carry_into_msb ^ cout;

endmodule