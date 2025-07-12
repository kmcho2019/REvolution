module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P_block,
    output wire       G_block
);
    wire [3:0] P; // propagate per bit
    wire [3:0] G; // generate per bit
    wire [4:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Carry lookahead logic for 4-bit block (explicit expressions)
    // Carry bits:
    // C1 = G0 | (P0 & C0)
    // C2 = G1 | (P1 & G0) | (P1 & P0 & C0)
    // C3 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & C0)
    // C4 = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & C0)
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Block propagate = P0 & P1 & P2 & P3
    assign P_block = &P;
    // Block generate = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    assign G_block = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule


module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    // Divide inputs into four 4-bit blocks
    wire [3:0] A_blk [3:0];
    wire [3:0] B_blk [3:0];
    wire [3:0] S_blk [3:0];

    wire       C_blk [4:0];      // carry signals between 4-bit blocks
    wire       P_blk [3:0];      // block propagate signals
    wire       G_blk [3:0];      // block generate signals

    assign C_blk[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : block_assign
            assign A_blk[i] = A[(i*4)+3 : i*4];
            assign B_blk[i] = B[(i*4)+3 : i*4];
        end
    endgenerate

    // Instantiate four 4-bit CLA blocks
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla4_inst
            cla_4bit cla4 (
                .A(A_blk[i]),
                .B(B_blk[i]),
                .Cin(C_blk[i]),
                .S(S_blk[i]),
                .Cout(),
                .P_block(P_blk[i]),
                .G_block(G_blk[i])
            );
        end
    endgenerate

    // Compute carries between 4-bit blocks using block propagate and generate
    // C_blk[i+1] = G_blk[i] | (P_blk[i] & C_blk[i])
    generate
        for (i = 0; i < 4; i = i + 1) begin : carry_block_calc
            if (i < 3) begin
                assign C_blk[i+1] = G_blk[i] | (P_blk[i] & C_blk[i]);
            end
        end
    endgenerate

    // Assign Cout = carry out of last 4-bit block
    assign Cout = G_blk[3] | (P_blk[3] & C_blk[3]);

    // Combine sums
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_concat
            assign S[(i*4)+3 : i*4] = S_blk[i];
        end
    endgenerate

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs [32:1] -> [31:0]
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

    // Lower 16-bit CLA block, Cin = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    // Upper 16-bit CLA block, Cin = C16
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Map sum outputs [31:0] -> [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule