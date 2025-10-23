module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] g, p;
    wire [3:1] carry;

    // Generate propagate and generate terms
    assign g = x & y;
    assign p = x ^ y;

    // Carry calculation
    assign carry[1] = g[0] | (p[0] & 1'b0);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);

    // Sum calculation
    assign sum[0] = p[0] ^ 1'b0;
    assign sum[1] = p[1] ^ carry[1];
    assign sum[2] = p[2] ^ carry[2];
    assign sum[3] = p[3] ^ carry[3];
    
    // Overflow (final carry-out)
    assign sum[4] = g[3] | (p[3] & carry[3]);
endmodule