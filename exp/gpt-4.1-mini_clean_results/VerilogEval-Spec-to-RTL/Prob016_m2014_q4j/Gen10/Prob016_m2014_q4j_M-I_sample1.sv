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

    assign c0 = 1'b0;

    // Generate and propagate signals
    assign g = x & y;
    assign p = x ^ y;

    // Carry-lookahead logic
    assign c1 = g[0] | (p[0] & c0);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign c4 = g[3] | (p[3] & c3);

    // sum bits
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;

    // Overflow bit (carry out)
    assign sum[4] = c4;

endmodule