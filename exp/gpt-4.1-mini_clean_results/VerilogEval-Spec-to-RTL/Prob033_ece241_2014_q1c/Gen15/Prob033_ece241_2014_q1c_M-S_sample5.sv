module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p = a ^ b;       // propagate
    wire [7:0] g = a & b;       // generate
    wire [8:0] c;               // carries: c[0]=0 (cin), c[8]=carry out

    // Calculate carry chain (carry lookahead)
    genvar i;
    assign c[0] = 1'b0;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_gen
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // sum bits = propagate XOR carry_in
    assign s = p ^ c[7:0];

    // Overflow = carry into MSB XOR carry out MSB
    assign overflow = c[7] ^ c[8];

endmodule