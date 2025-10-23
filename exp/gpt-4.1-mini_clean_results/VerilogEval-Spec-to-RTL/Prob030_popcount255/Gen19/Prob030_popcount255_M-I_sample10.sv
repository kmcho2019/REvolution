module popcount16 (
    input  [15:0] in,
    output [5:0] out  // 6 bits to count up to 16
);
    // Level 1: sum pairs of bits (2-bit sums)
    wire [1:0] s0  = in[0]  + in[1];
    wire [1:0] s1  = in[2]  + in[3];
    wire [1:0] s2  = in[4]  + in[5];
    wire [1:0] s3  = in[6]  + in[7];
    wire [1:0] s4  = in[8]  + in[9];
    wire [1:0] s5  = in[10] + in[11];
    wire [1:0] s6  = in[12] + in[13];
    wire [1:0] s7  = in[14] + in[15];

    // Level 2: sum pairs of 2-bit sums (3-bit sums)
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum pairs of 3-bit sums (4-bit sums)
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: sum two 4-bit sums (5-bit sum)
    wire [4:0] s14 = s12 + s13;

    assign out = s14; // max 16 fits in 5 bits, but keep 6 bits for consistency
endmodule

module popcount15 (
    input  [14:0] in,
    output [5:0] out  // 6 bits to count up to 15
);
    // Level 1: sum pairs of bits (2-bit sums), last bit leftover
    wire [1:0] s0  = in[0]  + in[1];
    wire [1:0] s1  = in[2]  + in[3];
    wire [1:0] s2  = in[4]  + in[5];
    wire [1:0] s3  = in[6]  + in[7];
    wire [1:0] s4  = in[8]  + in[9];
    wire [1:0] s5  = in[10] + in[11];
    wire [1:0] s6  = in[12] + in[13];
    wire leftover = in[14];

    // Level 2: sum pairs of 2-bit sums (3-bit sums)
    wire [2:0] s7 = s0 + s1;
    wire [2:0] s8 = s2 + s3;
    wire [2:0] s9 = s4 + s5;
    wire [2:0] s10 = s6 + 0; // no pair for s6, add 0

    // Level 3: sum pairs of 3-bit sums (4-bit sums)
    wire [3:0] s11 = s7 + s8;
    wire [3:0] s12 = s9 + s10;

    // Level 4: sum two 4-bit sums (5-bit sum)
    wire [4:0] s13 = s11 + s12;

    // Add leftover bit
    assign out = s13 + leftover;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split input into 15 chunks of 16 bits and 1 chunk of 15 bits
    // 15*16=240 bits + 15 bits = 255 bits total

    // Partial population counts
    wire [5:0] pc16_chunks [0:14];
    wire [5:0] pc15_chunk;

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : popcount16_chunks
            popcount16 u_pc16 (
                .in(in[i*16 +: 16]),
                .out(pc16_chunks[i])
            );
        end
    endgenerate

    popcount15 u_pc15 (
        .in(in[254:240]),
        .out(pc15_chunk)
    );

    // Flatten partial counts (16 partial counts of 6 bits each)
    wire [5:0] partial_counts [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin
            assign partial_counts[i] = pc16_chunks[i];
        end
    endgenerate
    assign partial_counts[15] = pc15_chunk;

    // Balanced adder tree for summing all 16 partial counts (each 6 bits)
    // Sum order:
    // Level 1: sum pairs -> 8 sums (7 bits)
    // Level 2: sum pairs -> 4 sums (8 bits)
    // Level 3: sum pairs -> 2 sums (9 bits)
    // Level 4: sum final pair -> 1 sum (10 bits max)
    // Since max popcount is 255, 8 bits are enough, but we keep wider bus to avoid overflow during sums.

    wire [6:0] sum_lvl1 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level1
            assign sum_lvl1[i] = partial_counts[2*i] + partial_counts[2*i + 1];
        end
    endgenerate

    wire [7:0] sum_lvl2 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2
            assign sum_lvl2[i] = sum_lvl1[2*i] + sum_lvl1[2*i + 1];
        end
    endgenerate

    wire [8:0] sum_lvl3 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3
            assign sum_lvl3[i] = sum_lvl2[2*i] + sum_lvl2[2*i + 1];
        end
    endgenerate

    wire [9:0] sum_lvl4;
    assign sum_lvl4 = sum_lvl3[0] + sum_lvl3[1];

    // Assign output (max count 255 fits in 8 bits)
    assign out = sum_lvl4[7:0];

endmodule