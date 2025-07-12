module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       Cin,
    output wire [7:0] S,
    output wire       Cout,
    output wire       P, // block propagate
    output wire       G  // block generate
);
    wire [7:0] p_bit; // propagate per bit
    wire [7:0] g_bit; // generate per bit
    wire [8:0] c;     // carry signals

    assign p_bit = A ^ B;
    assign g_bit = A & B;
    assign c[0] = Cin;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : carry_gen
            assign c[i+1] = g_bit[i] | (p_bit[i] & c[i]);
        end
    endgenerate

    assign S = p_bit ^ c[7:0];
    assign Cout = c[8];

    // Block propagate = AND of all p_bits
    assign P = &p_bit;

    // Block generate = G7 + P7*G6 + P7*P6*G5 + ... + P7*...*P0*Cin
    // Implemented with prefix generate chain
    wire [8:0] Gc;
    assign Gc[0] = 1'b0;
    generate
        for(i=1; i<=8; i=i+1) begin : block_gen_chain
            assign Gc[i] = g_bit[i-1] | (p_bit[i-1] & Gc[i-1]);
        end
    endgenerate
    assign G = Gc[8];
endmodule


module cla_4bit_block (
    input  wire [3:0] P, // block propagate from 4 blocks
    input  wire [3:0] G, // block generate from 4 blocks
    input  wire       Cin,
    output wire [3:0] C, // carry-in to each block (C[0] = Cin)
    output wire       Cout,
    output wire       P_out,
    output wire       G_out
);
    // Compute carries for 4 blocks using CLA logic
    // C[0] = Cin (input carry)
    // C[1] = G[0] + P[0]*Cin
    // C[2] = G[1] + P[1]*G[0] + P[1]*P[0]*Cin
    // C[3] = G[2] + P[2]*G[1] + P[2]*P[1]*G[0] + P[2]*P[1]*P[0]*Cin
    // Cout = G[3] + P[3]*G[2] + P[3]*P[2]*G[1] + P[3]*P[2]*P[1]*G[0] + P[3]*P[2]*P[1]*P[0]*Cin

    wire [3:0] c_internal;

    assign C[0] = Cin;

    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1]&P[0]&C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&C[0]);

    assign Cout = G[3] 
        | (P[3] & G[2]) 
        | (P[3] & P[2] & G[1]) 
        | (P[3] & P[2] & P[1] & G[0]) 
        | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign P_out = &P; // Block propagate is AND of all block propagates
    assign G_out = Cout; // Block generate equals carry-out

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);

    // Internal zero-based wires
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar i;

    // Map inputs from [32:1] to [31:0]
    generate
        for(i=0; i<32; i=i+1) begin : input_map_loop
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Split inputs into four 8-bit blocks
    wire [7:0] A_blk [3:0];
    wire [7:0] B_blk [3:0];
    generate
        for(i=0; i<4; i=i+1) begin : blk_split_loop
            assign A_blk[i] = A_int[8*i +: 8];
            assign B_blk[i] = B_int[8*i +: 8];
        end
    endgenerate

    // Wires for block sums, carries, P and G signals
    wire [7:0] S_blk [3:0];
    wire [3:0] P_blk;
    wire [3:0] G_blk;
    wire [3:0] C_blk; // Carry into each 8-bit block

    // Instantiate four 8-bit CLA blocks
    generate
        for(i=0; i<4; i=i+1) begin : cla8_blocks
            cla_8bit cla8_inst (
                .A(A_blk[i]),
                .B(B_blk[i]),
                .Cin(i==0 ? 1'b0 : C_blk[i]),
                .S(S_blk[i]),
                .Cout(),    // Not used at top-level, as carry computed by 4-bit CLA
                .P(P_blk[i]),
                .G(G_blk[i])
            );
        end
    endgenerate

    // Instantiate 4-bit CLA block to generate carries into each 8-bit block
    // Carry-in to block 0 = 0, to block 1 = C_blk[1], etc.
    // C_blk[0] unused because carry-in is 0, we set C_blk[0]=0 internally and assign carry-in explicitly in cla8_blocks instantiations
    wire carry_in = 1'b0;

    cla_4bit_block cla4_inst (
        .P(P_blk),
        .G(G_blk),
        .Cin(carry_in),
        .C(C_blk),
        .Cout(C32),
        .P_out(), // Not used externally
        .G_out()  // Not used externally
    );

    // Map sum outputs back to [32:1]
    generate
        for(i=0; i<4; i=i+1) begin : sum_map_loop
            genvar j;
            for(j=0; j<8; j=j+1) begin : inner_sum_loop
                assign S[i*8 + j + 1] = S_blk[i][j];
            end
        end
    endgenerate

endmodule