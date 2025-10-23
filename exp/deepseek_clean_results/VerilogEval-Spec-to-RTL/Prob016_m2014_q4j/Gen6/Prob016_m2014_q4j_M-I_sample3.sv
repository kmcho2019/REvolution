module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // Optimized full adder implementation
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | ((a | b) & cin);  // More efficient form
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Carry-lookahead logic
    wire [3:0] g = x & y;  // Generate terms
    wire [3:0] p = x | y;  // Propagate terms
    
    // Carry computation (lookahead)
    wire c1 = g[0] | (p[0] & 1'b0);
    wire c2 = g[1] | (p[1] & g[0]);
    wire c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
    wire c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Bit-wise sum computation using full adders
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout()  // Unused as we have lookahead carries
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout()
    );
    
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c2),
        .sum(sum[2]),
        .cout()
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c3),
        .sum(sum[3]),
        .cout()
    );
    
    // Final carry out
    assign sum[4] = c4;
endmodule