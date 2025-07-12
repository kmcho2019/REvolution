module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Generate and propagate signals
    wire [3:0] g = x & y;
    wire [3:0] p = x ^ y;
    
    // Carry lookahead logic
    wire c0 = g[0] | (p[0] & 1'b0);
    wire c1 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & 1'b0);
    wire c2 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & 1'b0);
    
    // Sum calculation
    assign sum[0] = p[0] ^ 1'b0;
    assign sum[1] = p[1] ^ c0;
    assign sum[2] = p[2] ^ c1;
    
    // Final bit uses ripple-carry to save area
    FullAdder fa3(x[3], y[3], c2, sum[3], sum[4]);
endmodule