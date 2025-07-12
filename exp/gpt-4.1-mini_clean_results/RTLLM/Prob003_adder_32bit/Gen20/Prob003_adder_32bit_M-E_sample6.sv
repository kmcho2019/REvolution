module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P_out, // Group propagate
    output        G_out  // Group generate
);
    // Internal propagate and generate signals for each bit
    wire [16:1] p;
    wire [16:1] g;
    wire [16:0] c; // carry signals: c[0]=Cin, c[16]=Cout

    assign p = A ^ B;   // propagate
    assign g = A & B;   // generate
    assign c[0] = Cin;

    // Carry lookahead for each bit:
    // c[i] = g[i] | (p[i] & c[i-1])
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_generate
            assign c[i] = g[i] | (p[i] & c[i-1]);
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    assign Cout = c[16];

    // Compute block propagate and generate signals for the 16-bit block
    // P_out = p1 & p2 & ... & p16
    // G_out = g16 | (p16 & g15) | (p16 & p15 & g14) | ... | (p16 & ... & p2 & g1)
    // Implemented efficiently using a tree of generate/propagate

    // Using a recursive function inside generate is tricky in Verilog,
    // so here we do it using prefix operators.

    wire [16:0] gp; // group propagate prefix: gp[i] = p[1] & ... & p[i]
    wire [16:0] gg; // group generate prefix

    assign gp[0] = 1'b1;
    assign gg[0] = 1'b0;

    generate
        for (i = 1; i <= 16; i = i + 1) begin : gp_gg_compute
            assign gp[i] = gp[i-1] & p[i];
            assign gg[i] = g[i] | (p[i] & gg[i-1]);
        end
    endgenerate

    assign P_out = gp[16];
    assign G_out = gg[16];

endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P_lower, G_lower;
    wire P_upper, G_upper;

    // Lower 16-bit CLA block (bits 1 to 16)
    cla_16bit cla_low (
        .A    (A[16:1]),
        .B    (B[16:1]),
        .Cin  (1'b0),
        .S    (S[16:1]),
        .Cout (C16),
        .P_out(P_lower),
        .G_out(G_lower)
    );

    // Upper 16-bit CLA block (bits 17 to 32)
    cla_16bit cla_high (
        .A    (A[32:17]),
        .B    (B[32:17]),
        .Cin  (C16),
        .S    (S[32:17]),
        .Cout (C32),
        .P_out(P_upper),
        .G_out(G_upper)
    );

    // Optional: top-level carry lookahead using group P and G of two 16-bit blocks:
    // Not required here since carry-in of lower is 0 and carry-in of upper is carry-out of lower.
    // This keeps design modular and easy to extend for bigger sizes.
endmodule