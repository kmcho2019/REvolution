module cla_16bit (
    input  wire [16:1] A,
    input  wire [16:1] B,
    input  wire        Cin,
    output wire [16:1] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    // Per bit generate and propagate
    wire [16:1] G_bit = A & B;
    wire [16:1] P_bit = A ^ B;

    // Define intermediate group generate and propagate signals at different levels

    // Level 1: pairs (2 bits)
    wire [8:1] G_2;
    wire [8:1] P_2;
    genvar i;
    generate
        for (i=1; i<=8; i=i+1) begin : level1
            assign G_2[i] = G_bit[2*i] | (P_bit[2*i] & G_bit[2*i-1]);
            assign P_2[i] = P_bit[2*i] & P_bit[2*i-1];
        end
    endgenerate

    // Level 2: groups of 4 bits
    wire [4:1] G_4;
    wire [4:1] P_4;
    generate
        for (i=1; i<=4; i=i+1) begin : level2
            assign G_4[i] = G_2[2*i] | (P_2[2*i] & G_2[2*i-1]);
            assign P_4[i] = P_2[2*i] & P_2[2*i-1];
        end
    endgenerate

    // Level 3: groups of 8 bits
    wire [2:1] G_8;
    wire [2:1] P_8;
    generate
        for (i=1; i<=2; i=i+1) begin : level3
            assign G_8[i] = G_4[2*i] | (P_4[2*i] & G_4[2*i-1]);
            assign P_8[i] = P_4[2*i] & P_4[2*i-1];
        end
    endgenerate

    // Level 4: group of 16 bits (whole block)
    assign G = G_8[2] | (P_8[2] & G_8[1]);
    assign P = P_8[2] & P_8[1];

    // Calculate carries for bits 1 to 16

    wire [16:0] C;
    assign C[0] = Cin;

    // Compute carries by hierarchical groupings to avoid long carry chains
    // Carry for bit 1
    assign C[1] = G_bit[1] | (P_bit[1] & C[0]);
    // Carry for bit 2
    assign C[2] = G_2[1] | (P_2[1] & C[0]);
    // Carry for bit 3
    assign C[3] = G_bit[3] | (P_bit[3] & C[2]);
    // Carry for bit 4
    assign C[4] = G_4[1] | (P_4[1] & C[0]);
    // Carry for bit 5
    assign C[5] = G_bit[5] | (P_bit[5] & C[4]);
    // Carry for bit 6
    assign C[6] = G_2[3] | (P_2[3] & C[4]);
    // Carry for bit 7
    assign C[7] = G_bit[7] | (P_bit[7] & C[6]);
    // Carry for bit 8
    assign C[8] = G_8[1] | (P_8[1] & C[0]);
    // Carry for bit 9
    assign C[9] = G_bit[9] | (P_bit[9] & C[8]);
    // Carry for bit 10
    assign C[10] = G_2[5] | (P_2[5] & C[8]);
    // Carry for bit 11
    assign C[11] = G_bit[11] | (P_bit[11] & C[10]);
    // Carry for bit 12
    assign C[12] = G_4[3] | (P_4[3] & C[8]);
    // Carry for bit 13
    assign C[13] = G_bit[13] | (P_bit[13] & C[12]);
    // Carry for bit 14
    assign C[14] = G_2[7] | (P_2[7] & C[12]);
    // Carry for bit 15
    assign C[15] = G_bit[15] | (P_bit[15] & C[14]);
    // Carry for bit 16
    assign C[16] = G | (P & C[0]);

    assign Cout = C[16];

    // Sum bits: Si = Pi xor Ci-1
    genvar j;
    generate
        for (j=1; j<=16; j=j+1) begin : sum_bits
            assign S[j] = P_bit[j] ^ C[j-1];
        end
    endgenerate

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire C16;
    wire P_low, G_low, P_high, G_high;

    // Lower 16 bits CLA
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Upper 16 bits CLA
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

endmodule