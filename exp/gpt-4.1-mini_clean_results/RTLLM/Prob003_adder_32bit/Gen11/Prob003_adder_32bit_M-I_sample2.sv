module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] P = A ^ B;  // Propagate bits
    wire [15:0] G = A & B;  // Generate bits

    // Group propagate and generate signals for 4 groups of 4 bits
    wire [3:0] gp, gg;

    genvar i;

    // Calculate group propagate and generate signals for each 4-bit group
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_pg
            assign gp[i] = &P[(4*i)+3 -: 4]; // AND of 4 propagate bits
            assign gg[i] = G[(4*i)+3] | (P[(4*i)+3] & G[(4*i)+2]) |
                           (P[(4*i)+3] & P[(4*i)+2] & G[(4*i)+1]) |
                           (P[(4*i)+3] & P[(4*i)+2] & P[(4*i)+1] & G[(4*i)+0]);
        end
    endgenerate

    // Compute carries into each 4-bit group using group generate/propagate
    wire [4:0] C;
    assign C[0] = Cin;
    assign C[1] = gg[0] | (gp[0] & C[0]);
    assign C[2] = gg[1] | (gp[1] & C[1]);
    assign C[3] = gg[2] | (gp[2] & C[2]);
    assign C[4] = gg[3] | (gp[3] & C[3]);

    // Compute internal carries within each 4-bit group
    wire [15:0] c_internal;

    generate
        for (i = 0; i < 4; i = i + 1) begin : intra_group_carry
            wire [3:0] Pi = P[(4*i)+3 -: 4];
            wire [3:0] Gi = G[(4*i)+3 -: 4];

            // Carries within group: c0 = carry-in to group
            // c1 = G0 + P0 * c0; c2 = G1 + P1*c1; c3 = G2 + P2*c2; c4 = G3 + P3*c3
            wire c0 = C[i];
            wire c1 = Gi[0] | (Pi[0] & c0);
            wire c2 = Gi[1] | (Pi[1] & c1);
            wire c3 = Gi[2] | (Pi[2] & c2);
            wire c4 = Gi[3] | (Pi[3] & c3);

            assign c_internal[(4*i)+0] = c0;
            assign c_internal[(4*i)+1] = c1;
            assign c_internal[(4*i)+2] = c2;
            assign c_internal[(4*i)+3] = c3;
            // Note: c4 is carry-out of group, already assigned as C[i+1]
        end
    endgenerate

    // Sum bits: S = P ^ carry-in to each bit
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_bits
            assign S[i] = P[i] ^ c_internal[i];
        end
    endgenerate

    assign Cout = C[4]; // Carry out of 16-bit adder
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire c16;

    // Remap 1-based indexing to 0-based internally
    wire [15:0] A_low  = A[16:1];
    wire [15:0] B_low  = B[16:1];
    wire [15:0] A_high = A[32:17];
    wire [15:0] B_high = B[32:17];

    wire [15:0] S_low, S_high;

    // Lower 16-bit CLA block with Cin=0
    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(c16)
    );

    // Upper 16-bit CLA block with Cin = carry-out from lower block
    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(c16),
        .S(S_high),
        .Cout(C32)
    );

    // Assign sum outputs back with 1-based indexing
    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;
endmodule