module popcount16(
    input  wire [15:0] in,
    output wire [4:0]  out
);
    // Count bits by summing smaller groups
    // Approach: sum nibbles (4 bits), each nibble count fits in 3 bits
    wire [2:0] c0, c1, c2, c3;

    // Count bits in each 4-bit nibble
    assign c0 = in[3:0][0] + in[3:0][1] + in[3:0][2] + in[3:0][3];
    assign c1 = in[7:4][0] + in[7:4][1] + in[7:4][2] + in[7:4][3];
    assign c2 = in[11:8][0] + in[11:8][1] + in[11:8][2] + in[11:8][3];
    assign c3 = in[15:12][0] + in[15:12][1] + in[15:12][2] + in[15:12][3];

    wire [6:0] sum_c = c0 + c1 + c2 + c3; // max 16 (5 bits enough)
    assign out = sum_c[4:0];
endmodule

module popcount15(
    input  wire [14:0] in,
    output wire [4:0]  out
);
    // Similar approach as popcount16 but for 15 bits
    // Count bits by summing 4-bit nibbles + remaining bits

    wire [2:0] c0, c1, c2;
    wire [1:0] c3; // last 3 bits + 1 zero bit to make 4 bits

    assign c0 = in[3:0][0] + in[3:0][1] + in[3:0][2] + in[3:0][3];
    assign c1 = in[7:4][0] + in[7:4][1] + in[7:4][2] + in[7:4][3];
    assign c2 = in[11:8][0] + in[11:8][1] + in[11:8][2] + in[11:8][3];
    assign c3 = in[14:12][0] + in[14:12][1] + in[14:12][2] + 0;

    wire [6:0] sum_c = c0 + c1 + c2 + c3; // max 15 (4 bits)
    assign out = sum_c[4:0];
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Split input into 15 chunks of 16 bits + 1 chunk of 15 bits
    // 16 chunks total: chunk0 - chunk14: 16 bits each; chunk15: 15 bits
    wire [4:0] c16 [0:14]; // 15 chunks * 5 bits popcount
    wire [4:0] c15;        // last chunk popcount

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : pc16_blocks
            popcount16 pc16_i(
                .in(in[i*16 +: 16]),
                .out(c16[i])
            );
        end
    endgenerate
    popcount15 pc15_inst(
        .in(in[240 +: 15]),
        .out(c15)
    );

    // Stage 1: Sum pairs of counts (16 inputs => 8 sums)
    // Input count widths = 5 bits, max sum = 31, sum width = 6 bits
    wire [5:0] sum_s1 [0:7];
    assign sum_s1[0] = c16[0] + c16[1];
    assign sum_s1[1] = c16[2] + c16[3];
    assign sum_s1[2] = c16[4] + c16[5];
    assign sum_s1[3] = c16[6] + c16[7];
    assign sum_s1[4] = c16[8] + c16[9];
    assign sum_s1[5] = c16[10] + c16[11];
    assign sum_s1[6] = c16[12] + c16[13];
    assign sum_s1[7] = c16[14] + c15;

    // Stage 2: Sum pairs again (8 => 4 sums)
    // Inputs are 6 bits (max 62), outputs 7 bits (max 124)
    wire [6:0] sum_s2 [0:3];
    assign sum_s2[0] = sum_s1[0] + sum_s1[1];
    assign sum_s2[1] = sum_s1[2] + sum_s1[3];
    assign sum_s2[2] = sum_s1[4] + sum_s1[5];
    assign sum_s2[3] = sum_s1[6] + sum_s1[7];

    // Stage 3: Sum pairs (4 => 2 sums)
    // Inputs 7 bits (max 124), outputs 8 bits (max 248)
    wire [7:0] sum_s3 [0:1];
    assign sum_s3[0] = sum_s2[0] + sum_s2[1];
    assign sum_s3[1] = sum_s2[2] + sum_s2[3];

    // Stage 4: Final sum (2 => 1 sum)
    // Inputs 8 bits (max 248), outputs 8 bits (max 255)
    wire [8:0] sum_s4;
    assign sum_s4 = sum_s3[0] + sum_s3[1];

    // Assign lower 8 bits of final sum to output (max 255 fits in 8 bits)
    assign out = sum_s4[7:0];
endmodule