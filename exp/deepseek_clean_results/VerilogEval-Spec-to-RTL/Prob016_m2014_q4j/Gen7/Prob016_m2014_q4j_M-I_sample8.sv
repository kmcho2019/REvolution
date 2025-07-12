module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] g, p;  // Generate and propagate terms
    wire [3:0] carry; // Carry signals
    
    // Generate and propagate terms
    assign g = x & y;
    assign p = x ^ y;
    
    // Carry lookahead logic
    assign carry[0] = g[0] | (p[0] & 1'b0);       // No initial carry
    assign carry[1] = g[1] | (p[1] & g[0]);
    assign carry[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
    assign carry[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                     (p[3] & p[2] & p[1] & g[0]);
    
    // Instantiate FullAdders with pre-computed carries
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout()  // Unused - we use lookahead carries
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout()
    );
    
    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout()
    );
    
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout()
    );
    
    // Final carry is the overflow bit
    assign sum[4] = carry[3];
endmodule