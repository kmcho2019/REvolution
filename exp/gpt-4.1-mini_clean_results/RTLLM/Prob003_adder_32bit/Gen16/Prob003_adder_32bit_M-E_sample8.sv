module cla_8bit (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire        Cin,
    output wire [7:0]  S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [7:0] P_bit = A ^ B; // propagate per bit
    wire [7:0] G_bit = A & B; // generate per bit

    // Compute carries C[0]..C[8], C[0]=Cin
    wire [8:0] C;
    assign C[0] = Cin;
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : carry_gen
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[7:0];
    assign Cout = C[8];

    // Block propagate = AND of all bit propagates
    assign P = &P_bit;

    // Block generate = G[7] + P[7]*G[6] + ... + P[7]*...*P[0]*Cin=0 (so ignores Cin)
    // This equals carry out with Cin=0, so compute using a prefix chain with Cin=0:
    wire [8:0] prefix_G;
    assign prefix_G[0] = 1'b0;
    generate
        for(i=1; i<=8; i=i+1) begin : block_gen_prefix
            assign prefix_G[i] = G_bit[i-1] | (P_bit[i-1] & prefix_G[i-1]);
        end
    endgenerate
    assign G = prefix_G[8];
endmodule

module cla_4bit_carry_lookahead (
    input  wire [3:0] P,
    input  wire [3:0] G,
    input  wire       Cin,
    output wire [4:0] C  // C[0] = Cin, C[1]..C[4] carry outs for each block
);
    assign C[0] = Cin;
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : carry_calc
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate
endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map input vectors from [32:1] to [31:0]
    wire [31:0] A_int = A[32:1];
    wire [31:0] B_int = B[32:1];

    // Split inputs into 4 groups of 8 bits (0-based indexing)
    wire [7:0] A_blk [3:0];
    wire [7:0] B_blk [3:0];

    genvar idx;
    generate
        for(idx=0; idx<4; idx=idx+1) begin : split_inputs
            assign A_blk[idx] = A_int[8*idx +: 8];
            assign B_blk[idx] = B_int[8*idx +: 8];
        end
    endgenerate

    // Outputs from each 8-bit CLA block
    wire [7:0] S_blk [3:0];
    wire       Cout_blk [3:0];
    wire       P_blk [3:0];
    wire       G_blk [3:0];

    // Carry inputs for each block (to be driven by top-level CLA)
    wire [4:0] C_blk; // C_blk[0] = 0, C_blk[1..4] calculated by CLA4

    assign C_blk[0] = 1'b0; // global Cin = 0

    // Instantiate four 8-bit CLA blocks
    generate
        for(idx=0; idx<4; idx=idx+1) begin : cla8_blocks
            cla_8bit cla_inst (
                .A(A_blk[idx]),
                .B(B_blk[idx]),
                .Cin(C_blk[idx]),
                .S(S_blk[idx]),
                .Cout(Cout_blk[idx]),
                .P(P_blk[idx]),
                .G(G_blk[idx])
            );
        end
    endgenerate

    // Instantiate 4-bit CLA to compute carries into each 8-bit block
    cla_4bit_carry_lookahead cla4_carry (
        .P(P_blk),
        .G(G_blk),
        .Cin(1'b0),
        .C(C_blk)
    );

    // Concatenate S_blk results into output sum vector with [32:1] mapping
    assign S[8*0 +:8]   = S_blk[0]; // bits [8:1]
    assign S[8*1 +:8]   = S_blk[1]; // bits [16:9]
    assign S[8*2 +:8]   = S_blk[2]; // bits [24:17]
    assign S[8*3 +:8]   = S_blk[3]; // bits [32:25]

    assign C32 = C_blk[4]; // final carry out of most significant block

endmodule