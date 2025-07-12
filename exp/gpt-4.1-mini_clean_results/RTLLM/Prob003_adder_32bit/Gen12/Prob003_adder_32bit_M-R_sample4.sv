module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P_out,
    output wire       G_out
);
    wire [3:0] P; // propagate per bit
    wire [3:0] G; // generate per bit
    wire [4:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Calculate carries within 4-bit block using carry lookahead equations
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];
    assign P_out = &P;       // Block propagate = all bits propagate
    assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]); // Block generate
endmodule

module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    wire [3:0] P_block, G_block;  // block propagate and generate for each 4-bit group
    wire [4:0] C;                 // carries for 4 groups + Cin

    assign C[0] = Cin;

    // Instantiate 4 blocks of 4-bit CLA
    genvar i;
    wire [3:0] S_sub [3:0];
    wire Cout_sub [3:0];

    generate
        for (i = 0; i < 4; i = i + 1) begin : cla4_blocks
            cla_4bit cla4 (
                .A(A[i*4 +: 4]),
                .B(B[i*4 +: 4]),
                .Cin(C[i]),
                .S(S_sub[i]),
                .Cout(Cout_sub[i]),
                .P_out(P_block[i]),
                .G_out(G_block[i])
            );
        end
    endgenerate

    // Calculate carries for the 4-bit blocks using CLA logic
    assign C[1] = G_block[0] | (P_block[0] & C[0]);
    assign C[2] = G_block[1] | (P_block[1] & G_block[0]) | (P_block[1] & P_block[0] & C[0]);
    assign C[3] = G_block[2] | (P_block[2] & G_block[1]) | (P_block[2] & P_block[1] & G_block[0]) | (P_block[2] & P_block[1] & P_block[0] & C[0]);
    assign C[4] = G_block[3] | (P_block[3] & G_block[2]) | (P_block[3] & P_block[2] & G_block[1]) | (P_block[3] & P_block[2] & P_block[1] & G_block[0]) | (P_block[3] & P_block[2] & P_block[1] & P_block[0] & C[0]);

    // Sum outputs are from sub-blocks
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_output
            assign S[i*4 +:4] = S_sub[i];
        end
    endgenerate

    assign Cout = C[4];
endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs from [32:1] to [31:0]
    wire [31:0] A_int, B_int;
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