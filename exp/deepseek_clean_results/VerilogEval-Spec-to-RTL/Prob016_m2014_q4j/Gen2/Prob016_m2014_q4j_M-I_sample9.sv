module FullAdderOpt(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // Optimized full adder implementation
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
    // Generate and propagate signals
    wire [3:0] p = x ^ y;
    wire [3:0] g = x & y;
    
    // Carry computation (CLA style)
    wire c0 = g[0] | (p[0] & 1'b0);
    wire c1 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & 1'b0);
    wire c2 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & 1'b0);
    wire c3 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    
    // Sum computation using optimized full adders
    FullAdderOpt fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout()
    );
    
    FullAdderOpt fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c0),
        .sum(sum[1]),
        .cout()
    );
    
    FullAdderOpt fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c1),
        .sum(sum[2]),
        .cout()
    );
    
    FullAdderOpt fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c2),
        .sum(sum[3]),
        .cout()
    );
    
    assign sum[4] = c3;
endmodule