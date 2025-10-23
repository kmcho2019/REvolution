module cla_4bit (
    input  wire [3:0] P,   // propagate signals for 4 bits
    input  wire [3:0] G,   // generate signals for 4 bits
    input  wire       Cin, // carry-in for the 4-bit group
    output wire [4:0] C,   // carry signals C[0]=Cin, C[4]=carry-out
    output wire       P_out, // group propagate
    output wire       G_out  // group generate
);
    // Hierarchical carry lookahead for 4 bits:
    // C[0] = Cin
    // C[1] = G[0] | (P[0] & C[0])
    // C[2] = G[1] | (P[1] & G[0]) | (P[1]&P[0]&C[0])
    // C[3] = G[2] | (P[2] & G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&C[0])
    // C[4] = G[3] | (P[3] & G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) | (P[3]&P[2]&P[1]&P[0]&C[0])

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign P_out = &P; // group propagate = AND of all propagates
    assign G_out = G[3] | (P[3] & G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]);
endmodule


module cla_16bit(
    input  wire [15:0] A,    // 16-bit operand A (bits 15 down to 0)
    input  wire [15:0] B,    // 16-bit operand B
    input  wire        Cin,  // Carry-in
    output wire [15:0] S,    // 16-bit sum
    output wire        Cout, // Carry-out
    output wire        P_block, // Group propagate for 16-bit block
    output wire        G_block  // Group generate for 16-bit block
);

    wire [15:0] P; // propagate signals for each bit
    wire [15:0] G; // generate signals for each bit
    wire [4:0] C_sub[3:0]; // carry signals inside 4-bit groups; each 5 bits wide
    wire [3:0] P_group;     // propagate signals for each 4-bit group
    wire [3:0] G_group;     // generate signals for each 4-bit group
    wire [4:0] C_group;     // carry signals between 4-bit groups; C_group[0]=Cin

    assign P = A ^ B;
    assign G = A & B;
    assign C_group[0] = Cin;

    genvar i;

    // Instantiate 4 instances of 4-bit CLA blocks
    generate
        for (i = 0; i < 4; i = i + 1) begin : four_bit_blocks
            cla_4bit cla4 (
                .P   (P[i*4 +: 4]),
                .G   (G[i*4 +: 4]),
                .Cin (C_group[i]),
                .C   (C_sub[i]),
                .P_out(P_group[i]),
                .G_out(G_group[i])
            );
        end
    endgenerate

    // Compute carries between 4-bit groups using carry lookahead on groups
    // Using same 4-bit CLA logic on group propagate and generate signals
    // For group carries, C_group has 5 elements: 0 to 4 (4 groups + carry out)
    cla_4bit cla4_group (
        .P(P_group),
        .G(G_group),
        .Cin(Cin),
        .C(C_group),
        .P_out(P_block),
        .G_out(G_block)
    );

    // Sum bits: S[i] = P[i] ^ C[i], where C[i] = carry into bit i = C_sub[group][bit]
    // The carry into bit i is C_sub[group][bit], note C_sub[group][0] = carry-in to that 4-bit block
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_bits
            // Determine group and bit index within group
            // group = i / 4, bit = i % 4
            wire [2:0] group = i[4:2];       // i / 4, range 0-3 (but i max 15)
            wire [1:0] bit_in_group = i[1:0]; // i % 4
            assign S[i] = P[i] ^ C_sub[group][bit_in_group];
        end
    endgenerate

    // Carry out of entire 16-bit block is carry out of last 4-bit group (C_group[4])
    assign Cout = C_group[4];

endmodule


module adder_32bit(
    input  wire [32:1] A,   // 32-bit input operand A, MSB at 32 down to LSB at 1
    input  wire [32:1] B,   // 32-bit input operand B
    output wire [32:1] S,   // 32-bit sum output
    output wire        C32   // Carry-out of the 32-bit addition
);

    // Map [32:1] inputs to zero-based internal vectors [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split into lower and upper 16-bit halves
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs from each 16-bit CLA
    wire [15:0] S_low;
    wire [15:0] S_high;

    wire C16;       // Carry-out from lower 16-bit block
    wire P0, G0;    // Propagate and generate from lower 16-bit block
    wire P1, G1;    // Propagate and generate from upper 16-bit block

    // Instantiate lower 16-bit CLA block (bits 0-15)
    cla_16bit lower_cla (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),    // Overall carry-in is zero
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    // Compute carry-in to upper 16-bit block using block propagate/generate signals:
    // Carry_in_upper = G0 | (P0 & Cin) where Cin = 0 => Carry_in_upper = G0
    wire Cin_upper = G0;

    // Instantiate upper 16-bit CLA block (bits 16-31)
    cla_16bit upper_cla (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_upper),
        .S(S_high),
        .Cout(C32),
        .P_block(P1),
        .G_block(G1)
    );

    // Combine lower and upper sums into output S [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : output_map_low
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : output_map_high
            assign S[idx+17] = S_high[idx];
        end
    endgenerate

endmodule