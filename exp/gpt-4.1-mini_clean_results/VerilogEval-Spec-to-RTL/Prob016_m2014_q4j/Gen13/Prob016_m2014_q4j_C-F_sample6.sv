module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    // sum = a XOR b XOR cin
    assign sum = a ^ b ^ cin;
    // cout = majority of (a,b,cin)
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] g, p;  // generate and propagate
    wire c0, c1, c2, c3, c4;
    wire [3:0] carry_out; // carry outputs from full adders (optional for verification)

    assign c0 = 1'b0;

    // Generate and propagate signals
    assign g = x & y;
    assign p = x ^ y;

    // Carry-lookahead logic
    assign c1 = g[0] | (p[0] & c0);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign c4 = g[3] | (p[3] & c3);

    // Instantiate FullAdders with precomputed carry-in signals
    FullAdder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(c0),
        .sum(sum[0]),
        .cout(carry_out[0])
    );

    FullAdder fa1 (
        .a(x[1]),
        .b(y[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(carry_out[1])
    );

    FullAdder fa2 (
        .a(x[2]),
        .b(y[2]),
        .cin(c2),
        .sum(sum[2]),
        .cout(carry_out[2])
    );

    FullAdder fa3 (
        .a(x[3]),
        .b(y[3]),
        .cin(c3),
        .sum(sum[3]),
        .cout(carry_out[3])
    );

    // Overflow bit (carry out)
    assign sum[4] = c4;

endmodule