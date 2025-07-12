module popcount17 (
    input  [16:0] in,
    output [5:0]  out // 6 bits: log2(17)+1=6 bits to count up to 17 ones
);
    // Level 1: sum pairs of bits (2-bit results)
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];
    wire [1:0] s4 = in[8] + in[9];
    wire [1:0] s5 = in[10] + in[11];
    wire [1:0] s6 = in[12] + in[13];
    wire [1:0] s7 = in[14] + in[15];
    wire leftover = in[16];

    // Level 2: sum pairs of 2-bit values (3-bit results)
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum pairs of 3-bit values (4-bit results)
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: sum two 4-bit values (5-bit result)
    wire [4:0] s14 = s12 + s13;

    // Final sum with leftover bit (6-bit output)
    assign out = s14 + leftover;
endmodule


module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Number of chunks of 17 bits for 255-bit input: 255/17 = 15
    localparam NUM_CHUNKS = 15;

    // Each chunk is 17 bits wide
    // Partial sums are 6 bits wide (max 17 ones)
    wire [5:0] partial_sum [0:NUM_CHUNKS-1];

    genvar i;
    generate
        // Instantiate popcount17 modules for each 17-bit chunk in parallel
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : gen_popcount17_chunks
            // Extract chunk bits from input
            wire [16:0] chunk_bits = in[i*17 +: 17];
            popcount17 pc17 (
                .in(chunk_bits),
                .out(partial_sum[i])
            );
        end
    endgenerate

    // Now sum the 15 partial sums (6 bits each) using a balanced binary adder tree

    // Level 1: sum pairs -> 7 sums + 1 leftover partial_sum (because 15 is odd)
    wire [6:0] sum_level1 [0:(NUM_CHUNKS/2)]; // 8 sums max

    generate
        for (i = 0; i < NUM_CHUNKS/2; i = i + 1) begin : gen_level1
            // Add pairs of 6-bit partial sums => max sum = 17+17=34 fits in 6 bits + 1 bit = 7 bits
            assign sum_level1[i] = partial_sum[2*i] + partial_sum[2*i+1];
        end
        // Handle leftover odd partial sum (the 15th)
        assign sum_level1[NUM_CHUNKS/2] = partial_sum[NUM_CHUNKS - 1];
    endgenerate

    localparam LEVEL1_SIZE = (NUM_CHUNKS/2)+1; // 8 sums

    // Level 2: sum pairs of 7-bit sums => max sum roughly 34+34=68 fits in 7 bits + 1 bit = 8 bits
    wire [7:0] sum_level2 [0:(LEVEL1_SIZE/2)-1]; // 4 sums

    generate
        for (i = 0; i < (LEVEL1_SIZE/2); i = i + 1) begin : gen_level2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i + 1];
        end
    endgenerate

    localparam LEVEL2_SIZE = (LEVEL1_SIZE/2); // 4 sums

    // Level 3: sum pairs of 8-bit sums => max sum ~68+68=136 fits in 8 bits + 1 bit = 9 bits
    wire [8:0] sum_level3 [0:(LEVEL2_SIZE/2)-1]; // 2 sums

    generate
        for (i = 0; i < (LEVEL2_SIZE/2); i = i + 1) begin : gen_level3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i + 1];
        end
    endgenerate

    localparam LEVEL3_SIZE = (LEVEL2_SIZE/2); // 2 sums

    // Level 4: final sum of two 9-bit sums => max sum ~136+136=272 fits in 9 bits + 1 bit = 10 bits
    wire [9:0] sum_level4;

    assign sum_level4 = sum_level3[0] + sum_level3[1];

    // The maximum count for 255 bits is 255, fits in 8 bits, so truncate output
    assign out = sum_level4[7:0];

endmodule