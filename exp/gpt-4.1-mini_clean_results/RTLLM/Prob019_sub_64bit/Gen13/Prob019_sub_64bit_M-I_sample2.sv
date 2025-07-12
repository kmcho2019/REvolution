module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Signals for 4 16-bit results and carry/borrow between blocks
    wire [15:0] R_seg [3:0];
    wire [4:0] borrow; // borrow signals between 16-bit blocks
    
    assign borrow[0] = 1'b1; // initial carry-in = 1 for A - B = A + (~B) + 1

    // Instantiate four 16-bit CLA subtractors for each segment
    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin : blk16
            sub_16bit_cla_lookahead u_sub16 (
                .A    (A[16*i +: 16]),
                .B    (B[16*i +: 16]),
                .cin  (borrow[i]),
                .result(R_seg[i]),
                .cout (borrow[i+1])
            );
        end
    endgenerate

    assign result = {R_seg[3], R_seg[2], R_seg[1], R_seg[0]};

    // Overflow detection:
    // Overflow occurs if A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit subtractor implemented as a carry-lookahead subtractor
// sum = A + (~B) + cin (cin=1 for subtraction)
// Implements full carry-lookahead logic to speed carry/borrow propagation inside 16-bit block
module sub_16bit_cla_lookahead (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] result,
    output wire        cout
);
    // Complement B once
    wire [15:0] B_neg = ~B;

    // Propagate and generate signals
    wire [15:0] P, G;
    wire [16:0] C; // carry signals, C[0] = cin

    assign P = A ^ B_neg;
    assign G = A & B_neg;
    assign C[0] = cin;

    // Generate carry-lookahead carry signals for 16 bits
    // Use hierarchical carry-lookahead for efficiency:
    // Divide into 4 groups of 4 bits
    wire [3:0] P_group, G_group;
    genvar i;

    generate
        for(i = 0; i < 16; i = i + 1) begin : bit_loop
            // No internal signals here, done below
        end
    endgenerate

    // Compute group propagate and generate for 4-bit groups
    // Each group covers bits: 0-3,4-7,8-11,12-15
    assign P_group[0] = &P[3:0]; // all P bits in group 0
    assign P_group[1] = &P[7:4];
    assign P_group[2] = &P[11:8];
    assign P_group[3] = &P[15:12];

    assign G_group[0] = G[3] | (P[3] & G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]);
    assign G_group[1] = G[7] | (P[7] & G[6]) | (P[7]&P[6]&G[5]) | (P[7]&P[6]&P[5]&G[4]);
    assign G_group[2] = G[11] | (P[11] & G[10]) | (P[11]&P[10]&G[9]) | (P[11]&P[10]&P[9]&G[8]);
    assign G_group[3] = G[15] | (P[15] & G[14]) | (P[15]&P[14]&G[13]) | (P[15]&P[14]&P[13]&G[12]);

    // Compute carries into each group using group propagate/generate
    wire [4:0] C_group;
    assign C_group[0] = C[0];
    assign C_group[1] = G_group[0] | (P_group[0] & C_group[0]);
    assign C_group[2] = G_group[1] | (P_group[1] & C_group[1]);
    assign C_group[3] = G_group[2] | (P_group[2] & C_group[2]);
    assign C_group[4] = G_group[3] | (P_group[3] & C_group[3]);

    // Compute internal carries in each 4-bit group using ripple carry within group
    // C[bit] = carry into bit position
    // For bit i in group j: i = j*4 + k (k=0..3)
    // C[j*4 + k + 1] = G[i] | (P[i] & C[j*4 + k])

    // Bits 0-3
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]); // matches C_group[1]

    // Bits 4-7
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]); // matches C_group[2]

    // Bits 8-11
    assign C[9]  = G[8]  | (P[8]  & C[8]);
    assign C[10] = G[9]  | (P[9]  & C[9]);
    assign C[11] = G[10] | (P[10] & C[10]);
    assign C[12] = G[11] | (P[11] & C[11]); // matches C_group[3]

    // Bits 12-15
    assign C[13] = G[12] | (P[12] & C[12]);
    assign C[14] = G[13] | (P[13] & C[13]);
    assign C[15] = G[14] | (P[14] & C[14]);
    assign C[16] = G[15] | (P[15] & C[15]); // cout

    assign result = P ^ C[15:0];
    assign cout = C[16];

endmodule