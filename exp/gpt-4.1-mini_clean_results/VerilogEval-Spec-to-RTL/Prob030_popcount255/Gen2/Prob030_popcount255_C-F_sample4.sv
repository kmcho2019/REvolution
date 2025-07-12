module TopModule (
    input  [254:0] in,
    output reg [7:0] out
);

    // Number of bits per chunk for partial population counts
    // 255 bits / 16 bits = 15.9375 chunks, so 16 chunks of 16 bits except the last is 255-15*16=15 bits
    localparam CHUNK_SIZE = 16;
    localparam NUM_CHUNKS = (255 + CHUNK_SIZE - 1) / CHUNK_SIZE;  // 16

    // Partial counts for each chunk (up to 16 bits => max count 16 fits in 5 bits)
    reg [4:0] partial_counts [0:NUM_CHUNKS-1];

    integer i, j;
    always @(*) begin
        // Calculate partial popcounts per chunk
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin
            integer chunk_start = i * CHUNK_SIZE;
            integer chunk_end = chunk_start + CHUNK_SIZE - 1;
            if (chunk_end > 254)
                chunk_end = 254;

            partial_counts[i] = 0;
            for (j = chunk_start; j <= chunk_end; j = j + 1) begin
                partial_counts[i] = partial_counts[i] + in[j];
            end
        end

        // Balanced tree summation of partial counts:
        // Level 1: sum pairs of partial_counts into sums_level1
        reg [6:0] sums_level1 [0:(NUM_CHUNKS/2)-1]; // Max sum of 2*16=32 fits in 6 bits, use 7 bits for safety
        for (i = 0; i < NUM_CHUNKS/2; i = i + 1) begin
            sums_level1[i] = partial_counts[2*i] + partial_counts[2*i + 1];
        end

        // If odd number of partial_counts (NUM_CHUNKS=16 even here), last element handling is not needed
        // Level 2: sum pairs of sums_level1 into sums_level2
        reg [7:0] sums_level2 [0:(NUM_CHUNKS/4)-1]; // Max sum of 2*32=64 fits in 7 bits, use 8 bits for safety
        for (i = 0; i < NUM_CHUNKS/4; i = i + 1) begin
            sums_level2[i] = sums_level1[2*i] + sums_level1[2*i + 1];
        end

        // Level 3: sum pairs of sums_level2 into sums_level3
        reg [7:0] sums_level3 [0:(NUM_CHUNKS/8)-1]; // Max sum 2*64=128 fits in 8 bits
        for (i = 0; i < NUM_CHUNKS/8; i = i + 1) begin
            sums_level3[i] = sums_level2[2*i] + sums_level2[2*i + 1];
        end

        // Level 4: sum pairs of sums_level3 into sums_level4
        // NUM_CHUNKS/16 = 1, so sums_level4 is a single value
        reg [7:0] sums_level4;
        sums_level4 = sums_level3[0] + sums_level3[1];

        out = sums_level4;
    end

endmodule