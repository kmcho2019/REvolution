module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    // Generate propagate and generate signals
    wire [3:0] p, g;
    assign p = x ^ y;     // propagate
    assign g = x & y;     // generate

    // Stage 1: Compute carries at bit 0 and bit 1
    wire g01, p01;
    assign g01 = g[1] | (p[1] & g[0]);
    assign p01 = p[1] & p[0];

    // Stage 2: Compute carries at bit 2
    wire g012, p012;
    assign g012 = g[2] | (p[2] & g01);
    assign p012 = p[2] & p01;

    // Stage 3: Compute carry at bit 3 (final carry-out)
    wire g0123;
    assign g0123 = g[3] | (p[3] & g012);

    // Compute carry inputs for each bit
    wire c0 = 1'b0;        // initial carry-in
    wire c1 = g[0] | (p[0] & c0);
    wire c2 = g01    | (p01    & c0);
    wire c3 = g012   | (p012   & c0);
    wire c4 = g0123  | (p[3]&p012 & c0); // final carry out (overflow)

    // Compute sum bits
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = c4;  // overflow bit
endmodule