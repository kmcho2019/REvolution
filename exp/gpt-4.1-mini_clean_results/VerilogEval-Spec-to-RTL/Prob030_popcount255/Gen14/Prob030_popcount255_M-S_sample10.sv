module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Number of full 8-bit chunks
    localparam CHUNK_SIZE = 8;
    localparam NUM_CHUNKS = 31; // 31*8=248 bits
    localparam REM_BITS = 7;    // 255-248=7 bits remaining

    wire [3:0] chunk_popcount [0:NUM_CHUNKS-1]; // max popcount in 8 bits = 8 (4 bits needed)
    wire [3:0] last_popcount; // popcount for last 7 bits

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : chunk_popcounts
            // Count number of 1s in each 8-bit chunk using addition of bits
            assign chunk_popcount[i] = in[i*CHUNK_SIZE +: CHUNK_SIZE][0]
                                     + in[i*CHUNK_SIZE +: CHUNK_SIZE][1]
                                     + in[i*CHUNK_SIZE +: CHUNK_SIZE][2]
                                     + in[i*CHUNK_SIZE +: CHUNK_SIZE][3]
                                     + in[i*CHUNK_SIZE +: CHUNK_SIZE][4]
                                     + in[i*CHUNK_SIZE +: CHUNK_SIZE][5]
                                     + in[i*CHUNK_SIZE +: CHUNK_SIZE][6]
                                     + in[i*CHUNK_SIZE +: CHUNK_SIZE][7];
        end
    endgenerate

    // Popcount for remaining 7 bits
    assign last_popcount = in[NUM_CHUNKS*CHUNK_SIZE +: REM_BITS][0]
                         + in[NUM_CHUNKS*CHUNK_SIZE +: REM_BITS][1]
                         + in[NUM_CHUNKS*CHUNK_SIZE +: REM_BITS][2]
                         + in[NUM_CHUNKS*CHUNK_SIZE +: REM_BITS][3]
                         + in[NUM_CHUNKS*CHUNK_SIZE +: REM_BITS][4]
                         + in[NUM_CHUNKS*CHUNK_SIZE +: REM_BITS][5]
                         + in[NUM_CHUNKS*CHUNK_SIZE +: REM_BITS][6];

    // Sum all partial popcounts (31 chunks * 4 bits + last 4 bits)
    // Maximum sum is 255 -> needs 8 bits
    integer j;
    reg [7:0] sum;
    always @(*) begin
        sum = last_popcount;
        for (j = 0; j < NUM_CHUNKS; j = j + 1) begin
            sum = sum + chunk_popcount[j];
        end
    end

    assign out = sum;
endmodule