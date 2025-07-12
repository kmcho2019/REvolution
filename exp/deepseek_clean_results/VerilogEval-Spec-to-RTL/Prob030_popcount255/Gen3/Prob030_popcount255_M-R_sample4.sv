module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);

// Parameters for the hierarchical counting
localparam CHUNKS = 32;
localparam BITS_PER_CHUNK = 8;

// First level: count 1s in 8-bit chunks (31 full chunks + 7 remaining bits)
wire [7:0] level1 [0:CHUNKS-1];
genvar i;
generate
    // Full 8-bit chunks
    for (i = 0; i < CHUNKS-1; i = i + 1) begin : level1_count
        assign level1[i] = in[i*BITS_PER_CHUNK +: BITS_PER_CHUNK];
    end
    // Last partial chunk (7 bits)
    assign level1[CHUNKS-1] = {1'b0, in[248 +: 7]};
endgenerate

// Hierarchical summation tree
wire [7:0] sum_stage1 [0:15];
wire [7:0] sum_stage2 [0:7];
wire [7:0] sum_stage3 [0:3];
wire [7:0] sum_stage4 [0:1];

// Stage 1: 16 sums
generate
    for (i = 0; i < 16; i = i + 1) begin : stage1_sum
        assign sum_stage1[i] = level1[i*2] + level1[i*2+1];
    end
endgenerate

// Stage 2: 8 sums
generate
    for (i = 0; i < 8; i = i + 1) begin : stage2_sum
        assign sum_stage2[i] = sum_stage1[i*2] + sum_stage1[i*2+1];
    end
endgenerate

// Stage 3: 4 sums
generate
    for (i = 0; i < 4; i = i + 1) begin : stage3_sum
        assign sum_stage3[i] = sum_stage2[i*2] + sum_stage2[i*2+1];
    end
endgenerate

// Stage 4: 2 sums
generate
    for (i = 0; i < 2; i = i + 1) begin : stage4_sum
        assign sum_stage4[i] = sum_stage3[i*2] + sum_stage3[i*2+1];
    end
endgenerate

// Final sum
assign out = sum_stage4[0] + sum_stage4[1];

endmodule