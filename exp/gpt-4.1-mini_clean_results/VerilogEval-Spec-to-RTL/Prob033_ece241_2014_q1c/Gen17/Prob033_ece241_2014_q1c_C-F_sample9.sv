// 4-bit Carry Lookahead Adder block with group propagate/generate outputs
module CLA4 (
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       pg,   // group propagate
    output       gg,   // group generate
    output       carry_into_msb // carry into bit 3 (MSB of this block)
);
    wire [3:0] p;  // propagate
    wire [3:0] g;  // generate
    wire [4:0] c;  // carry signals

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = cin;

    // Carry lookahead within 4 bits:
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign sum = p ^ c[3:0];
    assign cout = c[4];
    assign carry_into_msb = c[3];

    // Group propagate and generate signals:
    assign pg = &p;                     // group propagate = p0 & p1 & p2 & p3
    assign gg = g[3] | (p[3] & g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]);
endmodule

// 8-bit CLA using two 4-bit CLA blocks with hierarchical carry calculation
module CLA8 (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout,
    output       carry_into_msb // carry into bit 7 (MSB of full 8-bit)
);
    wire [3:0] sum_lo, sum_hi;
    wire       cout_lo, cout_hi;
    wire       pg_lo, gg_lo;
    wire       pg_hi, gg_hi;
    wire       c4; // carry into high 4-bit block

    // Low 4 bits adder
    CLA4 cla_lo (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum_lo),
        .cout(cout_lo),
        .pg(pg_lo),
        .gg(gg_lo),
        .carry_into_msb() // unused here
    );

    // Carry into high block using group generate/propagate from low block
    assign c4 = gg_lo | (pg_lo & cin);

    // High 4 bits adder
    CLA4 cla_hi (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(c4),
        .sum(sum_hi),
        .cout(cout_hi),
        .pg(pg_hi),
        .gg(gg_hi),
        .carry_into_msb(carry_into_msb)
    );

    assign sum = {sum_hi, sum_lo};
    assign cout = gg_hi | (pg_hi & c4);

endmodule


module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout;
    wire carry_into_msb;

    // Instantiate hierarchical 8-bit CLA with zero carry-in
    CLA8 adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    // Overflow = carry into MSB xor carry out of MSB (signed overflow detection)
    assign overflow = carry_into_msb ^ cout;

endmodule