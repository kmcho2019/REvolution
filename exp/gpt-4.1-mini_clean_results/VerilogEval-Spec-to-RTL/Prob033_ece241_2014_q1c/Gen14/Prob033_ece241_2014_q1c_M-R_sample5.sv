module EightBitCLAAdder (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout,
    output       carry_into_msb
);
    wire [7:0] p, g;
    wire [8:0] c;

    assign p = a ^ b;
    assign g = a & b;

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

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