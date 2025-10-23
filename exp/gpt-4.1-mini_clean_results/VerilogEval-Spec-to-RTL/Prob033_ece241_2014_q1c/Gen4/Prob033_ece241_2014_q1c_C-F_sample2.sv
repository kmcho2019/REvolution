module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p, g;    // propagate and generate signals
    wire [8:0] c;       // carry signals: c[0] = 0 initial carry-in

    assign c[0] = 1'b0; // initial carry-in is zero

    // Generate propagate and generate signals
    assign p = a ^ b;   // propagate = a XOR b
    assign g = a & b;   // generate  = a AND b

    genvar i;
    // Compute carries with simple carry-lookahead logic in generate loop
    // c[i+1] = g[i] | (p[i] & c[i])
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_generate
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // Sum bits: s[i] = p[i] XOR c[i]
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_generate
            assign s[i] = p[i] ^ c[i];
        end
    endgenerate

    // Overflow detection: XOR of carry into and out of MSB (bit 7)
    assign overflow = c[7] ^ c[8];

endmodule