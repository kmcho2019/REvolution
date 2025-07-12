module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    // Propagate and generate signals
    wire [3:0] p, g;
    wire [4:0] c;

    assign p = x ^ y;  // propagate = a xor b
    assign g = x & y;  // generate = a and b

    // Initial carry-in
    assign c[0] = 1'b0;

    // Carry Lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    // Sum bits: sum_i = p_i xor c_i
    assign sum[3:0] = p ^ c[3:0];

    // Final carry-out as MSB of sum
    assign sum[4] = c[4];
endmodule