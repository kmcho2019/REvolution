module TopModule (
    input  wire [3:0] x,
    input  wire [3:0] y,
    output wire [4:0] sum
);
    // Generate and Propagate signals for each bit
    wire [3:0] g; // generate
    wire [3:0] p; // propagate

    assign g = x & y;      // generate: when both bits are 1, carry will be generated
    assign p = x ^ y;      // propagate: if either bit is 1, carry-in propagates

    // Carry lookahead logic
    wire c0 = 1'b0;        // initial carry-in = 0
    wire c1, c2, c3, c4;

    assign c1 = g[0] | (p[0] & c0);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign c4 = g[3] | (p[3] & c3);

    // Sum bits calculation using propagate and carry-in
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;

    // Final carry-out bit as overflow
    assign sum[4] = c4;
endmodule