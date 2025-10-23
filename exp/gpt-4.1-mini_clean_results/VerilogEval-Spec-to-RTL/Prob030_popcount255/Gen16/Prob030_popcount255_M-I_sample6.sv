module popcount8 (
    input  [7:0] in,
    output [3:0] out
);
    // 8-bit popcount using parallel adders (adder tree)
    wire [3:0] level1 [3:0];
    // level1 sums of pairs of bits
    assign level1[0] = in[1] + in[0];
    assign level1[1] = in[3] + in[2];
    assign level1[2] = in[5] + in[4];
    assign level1[3] = in[7] + in[6];
    // level2 sums pairs of level1
    wire [4:0] level2_0 = level1[1] + level1[0];
    wire [4:0] level2_1 = level1[3] + level1[2];
    // final sum
    assign out = level2_0 + level2_1;
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out
);
    // 7-bit popcount implemented as 8-bit with MSB=0
    wire [3:0] tmp_out;
    popcount8 pc8 (
        .in({1'b0,in}),
        .out(tmp_out)
    );
    assign out = tmp_out;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Parameters
    localparam CHUNK_SIZE = 8;
    localparam NUM_FULL_CHUNKS = 31;
    localparam LAST_CHUNK_SIZE = 7;

    // Partial counts array (4-bit each)
    wire [3:0] partial_counts [0:NUM_FULL_CHUNKS]; 
    // 31 full 8-bit chunks and 1 last 7-bit chunk -> total 32 partial counts

    genvar i;
    generate
        for (i = 0; i < NUM_FULL_CHUNKS; i = i + 1) begin : gen_popcount8
            popcount8 pc8 (
                .in(in[i*CHUNK_SIZE +: CHUNK_SIZE]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Last chunk with 7 bits
    popcount7 pc7 (
        .in(in[254 -: LAST_CHUNK_SIZE]),
        .out(partial_counts[NUM_FULL_CHUNKS])
    );

    // Sum partial_counts (32 values of max 8, so max sum = 255)
    // Use a balanced tree of adders summing 4-bit values to produce final 8-bit count

    // We'll sum in stages to avoid long chains
    // Stage 1: sum pairs -> 16 sums (5-bit each max 8+8=16)
    wire [4:0] sum_stage1 [0:15];
    generate
        for (i=0; i<16; i=i+1) begin : gen_stage1
            assign sum_stage1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Stage 2: sum pairs -> 8 sums (6-bit each max 16+16=32)
    wire [5:0] sum_stage2 [0:7];
    generate
        for (i=0; i<8; i=i+1) begin : gen_stage2
            assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs -> 4 sums (7-bit each max 32+32=64)
    wire [6:0] sum_stage3 [0:3];
    generate
        for (i=0; i<4; i=i+1) begin : gen_stage3
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
        end
    endgenerate

    // Stage 4: sum pairs -> 2 sums (8-bit each max 64+64=128)
    wire [7:0] sum_stage4 [0:1];
    generate
        for (i=0; i<2; i=i+1) begin : gen_stage4
            assign sum_stage4[i] = sum_stage3[2*i] + sum_stage3[2*i+1];
        end
    endgenerate

    // Stage 5: final sum (8-bit max 128+127=255)
    assign out = sum_stage4[0] + sum_stage4[1];

endmodule