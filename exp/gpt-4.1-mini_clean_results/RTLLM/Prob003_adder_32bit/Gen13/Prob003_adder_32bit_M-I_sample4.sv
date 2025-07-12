module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P_group,
    output wire       G_group
);
    wire [3:0] P; // bit propagate
    wire [3:0] G; // bit generate
    wire [4:0] C; // carries

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Carry lookahead equations for 4-bit block:
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) 
                  | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Group propagate and generate for this 4-bit block
    assign P_group = &P; // all propagate
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule


module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    wire [3:0] P_group; // propagate for each 4-bit block
    wire [3:0] G_group; // generate for each 4-bit block
    wire [4:0] C;       // carry signals for 4 blocks

    assign C[0] = Cin;

    wire [3:0] S_block [3:0];
    wire       Cout_block [3:0];

    genvar i;

    // Instantiate four 4-bit CLA blocks
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla4_blocks
            cla_4bit cla4 (
                .A(A[i*4 +: 4]),
                .B(B[i*4 +: 4]),
                .Cin(C[i]),
                .S(S_block[i]),
                .Cout(Cout_block[i]),
                .P_group(P_group[i]),
                .G_group(G_group[i])
            );
        end
    endgenerate

    // Carry-lookahead for 4 groups (16 bits)
    // Using group P and G signals to compute carries into each 4-bit block:
    // Formula for carry signals C[1..4]:
    // C[1] = G0 + P0*Cin
    // C[2] = G1 + P1*G0 + P1*P0*Cin
    // C[3] = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    // C[4] = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*Cin

    // Already assigned C[0] = Cin, compute higher level C[1]..C[4]
    assign C[1] = G_group[0] | (P_group[0] & C[0]);
    assign C[2] = G_group[1] | (P_group[1] & G_group[0]) | (P_group[1] & P_group[0] & C[0]);
    assign C[3] = G_group[2] | (P_group[2] & G_group[1]) | (P_group[2] & P_group[1] & G_group[0]) 
                  | (P_group[2] & P_group[1] & P_group[0] & C[0]);
    assign C[4] = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) 
                  | (P_group[3] & P_group[2] & P_group[1] & G_group[0]) 
                  | (P_group[3] & P_group[2] & P_group[1] & P_group[0] & C[0]);

    // Connect carry-in signals for 4-bit blocks (already done in instantiation)
    // But now assign outputs and final carry out
    assign Cout = C[4];

    // Concatenate sum from 4 blocks
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_assign
            assign S[i*4 +: 4] = S_block[i];
        end
    endgenerate
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs from [32:1] to [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;

    // Lower 16-bit CLA block, carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    // Upper 16-bit CLA block, carry-in = C16
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Map sum outputs back to [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule