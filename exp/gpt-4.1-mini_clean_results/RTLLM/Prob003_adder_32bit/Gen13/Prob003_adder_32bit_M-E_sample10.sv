// 8-bit Carry Lookahead Adder Block
module cla_8bit (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire        Cin,
    output wire [7:0]  S,
    output wire        Cout,
    output wire        P,   // Block propagate
    output wire        G    // Block generate
);
    wire [7:0] P_bit;  // Propagate per bit
    wire [7:0] G_bit;  // Generate per bit
    wire [8:0] C;      // Carry signals

    assign P_bit = A ^ B;
    assign G_bit = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        // Carry lookahead logic: C[i+1] = G[i] + P[i]*C[i]
        for (i = 0; i < 8; i = i + 1) begin : carry_compute
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[7:0];
    assign Cout = C[8];

    // Block propagate: AND of all bit propagates
    assign P = &P_bit;

    // Block generate computed via hierarchical prefix generate
    // G = G[7] + P[7]*G[6] + P[7]*P[6]*G[5] + ... + P[7]*...*P[0]*Cin
    // We use a generate chain to compute this:
    wire [8:0] Gc;
    assign Gc[0] = 1'b0; // since Cin is considered separately
    generate
        for (i = 1; i <= 8; i = i + 1) begin : block_generate_chain
            assign Gc[i] = G_bit[i-1] | (P_bit[i-1] & Gc[i-1]);
        end
    endgenerate
    assign G = Gc[8];
endmodule


// 4-bit CLA block to generate carry-in for each 8-bit block from P/G signals
module super_cla_4bit (
    input  wire [3:0] P,   // Block propagate inputs
    input  wire [3:0] G,   // Block generate inputs
    input  wire       Cin, // Overall carry-in to the super CLA
    output wire [4:0] C    // Carry outputs for each block (C[0] = Cin)
);
    assign C[0] = Cin;

    // Compute carry for each block using CLA formula:
    // C[i+1] = G[i] + P[i]*C[i]
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : carry_calc
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate
endmodule


// Top level 32-bit CLA adder with four 8-bit CLA blocks and a 4-bit super CLA
module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based vectors for inputs
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split inputs into 4 blocks of 8 bits each
    wire [7:0] A_block [3:0];
    wire [7:0] B_block [3:0];
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : block_split
            assign A_block[idx] = A_int[(idx*8)+7 -: 8];
            assign B_block[idx] = B_int[(idx*8)+7 -: 8];
        end
    endgenerate

    // Outputs from each 8-bit CLA block
    wire [7:0] S_block [3:0];
    wire       C_block [3:0];   // Carry-out of each 8-bit block
    wire       P_block [3:0];   // Block propagate
    wire       G_block [3:0];   // Block generate

    // Carry-ins for each 8-bit block (from super CLA)
    wire [4:0] C_super;

    // Carry-in to the whole adder is zero
    assign C_super[0] = 1'b0;

    // Instantiate four 8-bit CLA blocks with carry-in from super CLA
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : cla8_blocks
            cla_8bit cla8_inst (
                .A   (A_block[idx]),
                .B   (B_block[idx]),
                .Cin (C_super[idx]),
                .S   (S_block[idx]),
                .Cout(C_block[idx]),
                .P   (P_block[idx]),
                .G   (G_block[idx])
            );
        end
    endgenerate

    // Instantiate super CLA to generate carry-ins for each 8-bit block
    super_cla_4bit super_cla_inst (
        .P   (P_block),
        .G   (G_block),
        .Cin (C_super[0]),
        .C   (C_super)
    );

    // Final carry-out is carry-out from last 8-bit block
    assign C32 = C_block[3];

    // Map sum outputs back to [32:1] 1-based indexing
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : sum_map
            for (int j = 0; j < 8; j = j + 1) begin : bits_in_block
                // The bit position in S is (idx*8 + j) + 1 for 1-based indexing
                assign S[(idx*8) + j + 1] = S_block[idx][j];
            end
        end
    endgenerate
endmodule