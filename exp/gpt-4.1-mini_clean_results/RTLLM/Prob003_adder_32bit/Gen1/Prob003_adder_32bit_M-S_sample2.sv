module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,  // block propagate
    output        G   // block generate
);
    wire [16:1] p; // propagate per bit
    wire [16:1] g; // generate per bit
    wire [16:0] c; // carry signals

    assign c[0] = Cin;

    genvar i;
    generate
        for(i=1; i<=16; i=i+1) begin : gen_pg
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Compute carries using simple CLA formula:
    // c[i] = g[i] | (p[i] & c[i-1])
    // This is a linear chain but still carry lookahead style.
    generate
        for(i=1; i<=16; i=i+1) begin : gen_carry
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    // Sum bits
    generate
        for(i=1; i<=16; i=i+1) begin : gen_sum
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    assign Cout = c[16];

    // Block propagate is AND of all p[i]
    assign P = &p[16:1];
    // Block generate is G16 plus P16 times Cin
    // G block is true if block will generate carry independent of Cin
    // We can express block generate using carries:
    // G = c[16] when Cin=0? Actually:
    // G = g[16] | (p[16] & g[15]) | ... or simply:
    // G = Cout when Cin=0 means ignore Cin; so G = carry generate excluding Cin
    // We can compute G by:
    // G = g[16] | (p[16] & g[15]) | (p[16]&p[15]&g[14]) ... etc.
    // Instead, to keep it simple, use:
    // G = Cout when Cin=0, so we set Cin=0 and compute c
    wire [16:0] c0;
    assign c0[0] = 1'b0;
    generate
        for(i=1; i<=16; i=i+1) begin : gen_c0
            assign c0[i] = g[i] | (p[i] & c0[i-1]);
        end
    endgenerate
    assign G = c0[16];
endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire P0, G0;    // Propagate and generate of lower 16-bit block
    wire P1, G1;    // Propagate and generate of upper 16-bit block
    wire C16;       // Carry out of lower 16-bit block (carry into upper)

    // Lower 16-bit CLA (bits 1 to 16)
    cla_16bit cla_lo(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .P(P0),
        .G(G0)
    );

    // Carry into upper block
    // Carry-in to upper block = G0 + P0 * 0 = G0 (since carry-in=0)
    wire Cin_hi = G0; // Actually, Cin_hi = G0 | (P0 & 0) = G0

    // Upper 16-bit CLA (bits 17 to 32)
    cla_16bit cla_hi(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cin_hi),
        .S(S[32:17]),
        .Cout(C32),
        .P(P1),
        .G(G1)
    );
endmodule