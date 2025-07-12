module cla_16bit (
    input  wire [16:1] A,
    input  wire [16:1] B,
    input  wire        Cin,
    output wire [16:1] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    // Generate and propagate signals per bit
    wire [16:1] G_internal;
    wire [16:1] P_internal;
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : gp_bits
            assign G_internal[i] = A[i] & B[i];
            assign P_internal[i] = A[i] ^ B[i];
        end
    endgenerate

    // Parallel prefix carry computation using a balanced tree (Kogge-Stone style)
    // We use pairs of (G,P) to compute group generate/propagate:
    // (G,P) o (G',P') = (G + P*G', P*P')

    // Stage wires: Each stage halves the number of groups combined
    // Carry in at position 0 = Cin
    wire [16:0] carry; 
    assign carry[0] = Cin;

    // Define group propagate and generate arrays for each stage
    wire [16:1] G_level1, P_level1;
    wire [16:1] G_level2, P_level2;
    wire [16:1] G_level3, P_level3;
    wire [16:1] G_level4, P_level4;

    // Level 0 (initial): per bit G and P
    // Level 1: combine pairs of 1 bit (distance = 1)
    generate
        for (i = 1; i <= 16; i = i +1) begin : level0_to_level1
            if (i == 1) begin
                assign G_level1[i] = G_internal[i];
                assign P_level1[i] = P_internal[i];
            end else begin
                assign G_level1[i] = G_internal[i] | (P_internal[i] & G_internal[i-1]);
                assign P_level1[i] = P_internal[i] & P_internal[i-1];
            end
        end
    endgenerate

    // Level 2: combine pairs at distance 2
    generate
        for (i = 1; i <= 16; i = i +1) begin : level1_to_level2
            if (i <= 2) begin
                assign G_level2[i] = G_level1[i];
                assign P_level2[i] = P_level1[i];
            end else begin
                assign G_level2[i] = G_level1[i] | (P_level1[i] & G_level1[i-2]);
                assign P_level2[i] = P_level1[i] & P_level1[i-2];
            end
        end
    endgenerate

    // Level 3: combine pairs at distance 4
    generate
        for (i = 1; i <= 16; i = i +1) begin : level2_to_level3
            if (i <= 4) begin
                assign G_level3[i] = G_level2[i];
                assign P_level3[i] = P_level2[i];
            end else begin
                assign G_level3[i] = G_level2[i] | (P_level2[i] & G_level2[i-4]);
                assign P_level3[i] = P_level2[i] & P_level2[i-4];
            end
        end
    endgenerate

    // Level 4: combine pairs at distance 8
    generate
        for (i = 1; i <= 16; i = i +1) begin : level3_to_level4
            if (i <= 8) begin
                assign G_level4[i] = G_level3[i];
                assign P_level4[i] = P_level3[i];
            end else begin
                assign G_level4[i] = G_level3[i] | (P_level3[i] & G_level3[i-8]);
                assign P_level4[i] = P_level3[i] & P_level3[i-8];
            end
        end
    endgenerate

    // Compute carries:
    // carry[i] = G_level4[i-1] | (P_level4[i-1] & carry[0]) for i=1..16
    generate
        for (i = 1; i <= 16; i = i +1) begin : carry_compute
            assign carry[i] = G_level4[i] | (P_level4[i] & carry[0]);
        end
    endgenerate

    // Sum bits: S[i] = P_internal[i] ^ carry[i-1]
    generate
        for (i = 1; i <= 16; i = i + 1) begin : sum_bits
            assign S[i] = P_internal[i] ^ carry[i-1];
        end
    endgenerate

    assign Cout = carry[16];

    // Block propagate = AND of all P_internal bits
    assign P = &P_internal;

    // Block generate = G_level4[16] (top level group generate)
    assign G = G_level4[16];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire C16;
    wire P_low, G_low, P_high, G_high;

    // Lower 16 bits CLA (Cin=0)
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Upper 16 bits CLA (Cin=C16)
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