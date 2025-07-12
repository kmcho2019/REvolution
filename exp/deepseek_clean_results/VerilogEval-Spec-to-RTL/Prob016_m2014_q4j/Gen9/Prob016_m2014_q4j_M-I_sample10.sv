module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output p,
    output g
);
    // Optimized full adder with propagate and generate outputs
    assign sum = a ^ b ^ cin;
    assign p = a ^ b;       // Propagate term
    assign g = a & b;       // Generate term
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] p, g;
    wire [3:1] carry;

    // Bit 0 (LSB)
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .p(p[0]),
        .g(g[0])
    );

    // Bit 1
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[1]),
        .sum(sum[1]),
        .p(p[1]),
        .g(g[1])
    );

    // Bit 2
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(carry[2]),
        .sum(sum[2]),
        .p(p[2]),
        .g(g[2])
    );

    // Bit 3 (MSB)
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[3]),
        .sum(sum[3]),
        .p(p[3]),
        .g(g[3])
    );

    // Carry Lookahead Logic
    // Carry[1] = g0 | (p0 & cin)
    assign carry[1] = g[0] | (p[0] & 1'b0);
    
    // Carry[2] = g1 | (p1 & g0)
    assign carry[2] = g[1] | (p[1] & g[0]);
    
    // Carry[3] = g2 | (p2 & g1) | (p2 & p1 & g0)
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
    
    // Overflow bit (carry out)
    assign sum[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule