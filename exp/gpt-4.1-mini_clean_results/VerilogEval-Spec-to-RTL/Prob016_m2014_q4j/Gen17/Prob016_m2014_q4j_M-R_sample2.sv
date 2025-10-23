module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] g, p;     // generate and propagate
    wire [4:0] c;        // carry signals: c[0] = 0

    assign c[0] = 1'b0;

    // Generate and propagate signals
    assign g = x & y;
    assign p = x ^ y;

    // Carry-lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    // Sum bits: sum[i] = p[i] XOR carry-in
    assign sum[3:0] = p ^ c[3:0];

    // Overflow bit
    assign sum[4] = c[4];
endmodule