module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p; // propagate
    wire [3:0] g; // generate
    wire [4:0] c; // carry

    assign p = x ^ y;        // propagate = A xor B
    assign g = x & y;        // generate = A and B
    assign c[0] = 1'b0;      // carry in

    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // Sum bits
    assign sum = p ^ c[3:0];  // sum[i] = p[i] xor c[i]

    // Final carry out as MSB sum bit
    assign sum[4] = c[4];
endmodule