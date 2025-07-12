module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // Optimized full adder with shared terms
    wire p = a ^ b;
    wire g = a & b;
    
    assign sum = p ^ cin;
    assign cout = g | (p & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Propagate and Generate terms
    wire [3:0] p = x ^ y;
    wire [3:0] g = x & y;
    
    // Carry Lookahead Logic
    wire [3:1] carry;
    assign carry[1] = g[0] | (p[0] & 1'b0);  // c1 = g0 + p0·c0 (c0=0)
    assign carry[2] = g[1] | (p[1] & g[0]);   // c2 = g1 + p1·g0
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]); // c3 = g2 + p2·g1 + p2·p1·g0
    
    // Final carry-out (overflow)
    assign sum[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    
    // Sum computation using optimized full adders
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout()  // unused as we're using lookahead
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[1]),
        .sum(sum[1]),
        .cout()
    );
    
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(carry[2]),
        .sum(sum[2]),
        .cout()
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[3]),
        .sum(sum[3]),
        .cout()
    );
endmodule