module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        Pout,
    output        Gout
);

    wire [16:1] P; // Propagate per bit
    wire [16:1] G; // Generate per bit
    wire [4:0] C;  // Carry per 4-bit group boundaries: C[0] = Cin, C[4] = Cout

    // Compute bitwise propagate and generate
    assign P = A ^ B;
    assign G = A & B;

    // Compute group propagate and generate for 4-bit groups
    wire [3:0] Pg; // propagate per 4-bit group
    wire [3:0] Gg; // generate per 4-bit group

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : grp_pg_g
            // bits in group: 4*i+1 to 4*i+4
            // Propagate group: AND of all 4 bits propagate
            assign Pg[i] = &P[4*i+4 : 4*i+1];
            // Generate group: G[MSB] + P[MSB]G[MSB-1] + P[MSB]P[MSB-1]G[MSB-2] + ... 
            // Equivalent to carry-out from 4-bit ripple carry inside group when Cin=0
            assign Gg[i] = G[4*i+4]
                        | (P[4*i+4] & G[4*i+3])
                        | (P[4*i+4] & P[4*i+3] & G[4*i+2])
                        | (P[4*i+4] & P[4*i+3] & P[4*i+2] & G[4*i+1]);
        end
    endgenerate

    // Compute carries for each 4-bit group boundary
    // C[0] = Cin, then:
    // C[i] = Gg[i-1] + Pg[i-1] * C[i-1]
    assign C[0] = Cin;
    assign C[1] = Gg[0] | (Pg[0] & C[0]);
    assign C[2] = Gg[1] | (Pg[1] & C[1]);
    assign C[3] = Gg[2] | (Pg[2] & C[2]);
    assign C[4] = Gg[3] | (Pg[3] & C[3]);
    assign Cout = C[4];

    // Within each 4-bit group, compute carries for each bit
    // Define carry signals for bits 0 to 16 (0 = Cin)
    wire [16:0] bit_carry;
    assign bit_carry[0] = Cin;

    generate
        for (i=0; i<4; i=i+1) begin : bit_carries_per_group
            // For bits in group i: 4*i+1 to 4*i+4
            // First bit carry = group's carry in: bit_carry[4*i] = C[i]
            // Then use CLA formula inside group:
            // c1 = g0 + p0*c0
            // c2 = g1 + p1*g0 + p1*p0*c0
            // c3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*c0
            wire [4:1] p_sub = P[4*i+4 : 4*i+1];
            wire [4:1] g_sub = G[4*i+4 : 4*i+1];
            wire c_in = C[i]; // group's carry-in

            assign bit_carry[4*i+1] = g_sub[1] | (p_sub[1] & c_in);
            assign bit_carry[4*i+2] = g_sub[2] | (p_sub[2] & g_sub[1]) | (p_sub[2] & p_sub[1] & c_in);
            assign bit_carry[4*i+3] = g_sub[3] | (p_sub[3] & g_sub[2]) | (p_sub[3] & p_sub[2] & g_sub[1]) | (p_sub[3] & p_sub[2] & p_sub[1] & c_in);
            assign bit_carry[4*i+4] = g_sub[4] | (p_sub[4] & g_sub[3]) | (p_sub[4] & p_sub[3] & g_sub[2]) | (p_sub[4] & p_sub[3] & p_sub[2] & g_sub[1])
                                     | (p_sub[4] & p_sub[3] & p_sub[2] & p_sub[1] & c_in);
        end
    endgenerate

    // Compute sum bits: S[i] = P[i] XOR carry[i-1]
    generate
        for (i=1; i<=16; i=i+1) begin : sum_bits
            assign S[i] = P[i] ^ bit_carry[i-1];
        end
    endgenerate

    // Compute block propagate and generate for 16 bits:
    // Pout = AND of all P bits
    assign Pout = &P[16:1];

    // Gout = Gg[3] + Pg[3]*Gg[2] + Pg[3]*Pg[2]*Gg[1] + Pg[3]*Pg[2]*Pg[1]*Gg[0]
    //       + Pg[3]*Pg[2]*Pg[1]*Pg[0]*Cin (but Cin not included here for group generate)
    assign Gout = Gg[3] | (Pg[3] & Gg[2]) | (Pg[3] & Pg[2] & Gg[1]) | (Pg[3] & Pg[2] & Pg[1] & Gg[0]);

endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);

    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Instantiate lower 16 bits CLA (bits 1 to 16)
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .Pout(P_low),
        .Gout(G_low)
    );

    // Instantiate upper 16 bits CLA (bits 17 to 32)
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32),
        .Pout(P_high),
        .Gout(G_high)
    );

endmodule