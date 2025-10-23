module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] sum;
    wire        cout;

    // Instantiate 64-bit Kogge-Stone based subtractor (A + ~B + 1)
    kogge_stone_subtractor_64 ks_sub (
        .A    (A),
        .B    (B),
        .cin  (1'b1),  // +1 for two's complement subtraction
        .sum  (sum),
        .cout (cout)
    );

    assign result = sum;

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit Kogge-Stone Prefix Subtractor: sum = A + (~B) + cin
module kogge_stone_subtractor_64 (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);

    // Invert B internally for subtraction
    wire [63:0] B_comp = ~B;

    // Generate propagate and generate signals
    wire [63:0] P = A ^ B_comp;      // propagate = A xor B_comp
    wire [63:0] G = A & B_comp;      // generate  = A and B_comp

    // Prefix carry wires: we need 64 carry bits, C[0] = cin
    wire [63:0] carry;
    assign carry[0] = cin;

    // Kogge-Stone prefix carry generation
    // Each level combines generate and propagate pairs for 2^level bits
    
    // We implement the prefix network in 6 stages (since 2^6=64)
    // At each stage: compute new G and P pairs as follows:
    // G_out = G_i | (P_i & G_j), P_out = P_i & P_j, where j = i - 2^level

    // For each bit, keep track of current G and P:
    reg [63:0] G_stage [0:6];
    reg [63:0] P_stage [0:6];

    integer i;
    initial begin
        for (i=0; i<64; i=i+1) begin
            G_stage[0][i] = G[i];
            P_stage[0][i] = P[i];
        end
    end

    genvar level;
    generate
        for (level = 1; level <= 6; level = level + 1) begin : prefix_levels
            // distance = 2^(level-1)
            localparam DIST = 1 << (level - 1);
            // Use wires for combinational assignments
            wire [63:0] G_next;
            wire [63:0] P_next;

            for (i = 0; i < 64; i = i + 1) begin : bit_loop
                if (i < DIST) begin
                    assign G_next[i] = G_stage[level-1][i];
                    assign P_next[i] = P_stage[level-1][i];
                end else begin
                    assign G_next[i] = G_stage[level-1][i] | (P_stage[level-1][i] & G_stage[level-1][i - DIST]);
                    assign P_next[i] = P_stage[level-1][i] & P_stage[level-1][i - DIST];
                end
            end

            // Update registers for next stage
            always @(*) begin
                for (i=0; i<64; i=i+1) begin
                    G_stage[level][i] = G_next[i];
                    P_stage[level][i] = P_next[i];
                end
            end
        end
    endgenerate

    // The carry-in to bit i+1 is G_stage[6][i] OR (P_stage[6][i] & cin)
    // carry[0] = cin already assigned

    // Calculate carry[1] to carry[64]
    wire [63:0] carry_internal;
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_calc
            assign carry_internal[i] = G_stage[6][i] | (P_stage[6][i] & cin);
        end
    endgenerate

    // Assign carry bits shifted by 1: carry[i+1] = carry_internal[i]
    assign carry[1+:64] = carry_internal;

    // sum[i] = P[i] xor carry[i]
    assign sum = P ^ carry;

    // cout = carry out of last bit = carry[64]
    // Since carry is declared [63:0], carry[64] = G_stage[6][63] | (P_stage[6][63] & cin)
    assign cout = G_stage[6][63] | (P_stage[6][63] & cin);

endmodule