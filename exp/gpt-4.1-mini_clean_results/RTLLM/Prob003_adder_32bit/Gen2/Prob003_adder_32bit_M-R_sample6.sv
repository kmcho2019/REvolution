module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,    // Group propagate
    output        G     // Group generate
);
    wire [16:1] p, g;
    wire [16:0] c;

    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_pg
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Carry generation using generate loop
    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_carry
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    // Sum calculation
    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_sum
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    // Group propagate: AND of all bit propagates
    assign P = &p[16:1];

    // Group generate: G = g16 + p16*g15 + p16*p15*g14 + ... + p16*...*p2*g1
    // Use a loop to accumulate G by walking from LSB to MSB
    // We use a reduction variable 'gen_acc' to hold propagate chain so far

    wire [16:1] p_chain;
    wire [16:1] g_shifted; // g shifted for convenience

    assign g_shifted = g;

    // Calculate G using an iterative accumulate of (p chain) & g terms
    // G = OR over i of (g[i] & product of p[j] for j=i+1 to 16)
    // Compute product of p from MSB down to i+1 for each i

    // To implement this without loops at runtime, build propagate suffix products from MSB downward
    wire [17:1] p_suffix; // p_suffix[i] = product of p from i to 16, with p_suffix[17]=1
    assign p_suffix[17] = 1'b1;

    generate
        for (i = 16; i >= 1; i = i - 1) begin : gen_psuffix
            assign p_suffix[i] = p[i] & p_suffix[i+1];
        end
    endgenerate

    // Now G = OR over i=1 to 16 of (g[i] & p_suffix[i+1])
    // p_suffix[17] = 1, so for i=16, p_suffix[17] = 1 (meaning no propagate after bit 16)
    wire [16:1] gen_terms;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_g_terms
            assign gen_terms[i] = g[i] & p_suffix[i+1];
        end
    endgenerate

    assign G = |gen_terms;

    // Carry out
    assign Cout = c[16];
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P0, G0;
    wire P1, G1;

    // Lower 16 bits CLA
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P0),
        .G   (G0)
    );

    // Upper 16 bits CLA: carry-in is C16 from lower block
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32),
        .P   (P1),
        .G   (G1)
    );
endmodule