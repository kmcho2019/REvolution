module adder_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         cin,
    output [16:1] S,
    output        P_group,
    output        G_group,
    output        cout
);
    // Generate and Propagate signals for each bit
    wire [16:1] G; // Generate
    wire [16:1] P; // Propagate

    assign G = A & B;
    assign P = A ^ B;

    // Carry signals
    wire [16:0] C;
    assign C[0] = cin;

    // Carry-lookahead logic for 16 bits
    // Carry[i] = G[i] | (P[i] & Carry[i-1])
    genvar i;
    generate
        for (i=1; i<=16; i=i+1) begin : carry_gen
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    assign S = P ^ C[15:0]; // Sum bits: S[i] = P[i] ^ C[i-1]

    // Group Propagate: P_group = P1 & P2 & ... & P16
    assign P_group = &P;

    // Group Generate:
    // G_group = G16 | (P16 & G15) | (P16 & P15 & G14) | ... | (P16 & ... & P2 & G1)
    // We'll implement by recursion or generate a tree
    wire [16:1] PG_and; // partial propagate AND from i up to 16

    // Partial AND for group generate calculation
    assign PG_and[16] = P[16];
    genvar j;
    generate
        for (j=15; j>=1; j=j-1) begin : pg_and_gen
            assign PG_and[j] = P[j] & PG_and[j+1];
        end
    endgenerate

    // Compute group generate by expansion
    // G_group = G[16] 
    //           | (P[16] & G[15]) 
    //           | (P[16] & P[15] & G[14]) 
    //           | ...
    //           | (P[16] & P[15] & ... & P[2] & G[1])
    // We'll implement with a generate loop and OR reduction
    wire [16:1] gen_terms;
    generate
        for (j=1; j<=16; j=j+1) begin : gen_term_calc
            if (j == 16) begin
                assign gen_terms[j] = G[16];
            end else begin
                // product of P[j+1..16]
                // equals PG_and[j+1]
                assign gen_terms[j] = G[j] & PG_and[j+1];
            end
        end
    endgenerate

    assign G_group = |gen_terms;

    assign cout = C[16];

endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire P0, G0, C16;
    wire P1, G1;

    // Lower 16 bits
    adder_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(1'b0),
        .S(S[16:1]),
        .P_group(P0),
        .G_group(G0),
        .cout()
    );

    // Compute carry-in for upper block (C16)
    // C16 = G0 | (P0 & cin)
    // Since cin=0, C16 = G0
    assign C16 = G0;

    // Upper 16 bits
    adder_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .cin(C16),
        .S(S[32:17]),
        .P_group(P1),
        .G_group(G1),
        .cout(C32)
    );

endmodule