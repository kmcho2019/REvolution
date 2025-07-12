module popcount16 (
    input  [15:0] in,
    output [4:0] out  // max 16 ones -> 5 bits
);
    // Sum bits in groups to reduce logic complexity
    wire [7:0] sum2;
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : pair_sum
            assign sum2[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [4:0] sum4 [3:0];
    generate
        for(i=0; i<4; i=i+1) begin : quartet_sum
            assign sum4[i] = sum2[2*i] + sum2[2*i+1];
        end
    endgenerate

    wire [5:0] sum8_0 = sum4[0] + sum4[1];
    wire [5:0] sum8_1 = sum4[2] + sum4[3];
    wire [6:0] sum16 = sum8_0 + sum8_1;
    assign out = sum16[4:0]; // max 16, fits in 5 bits
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input into 16 groups: 15 full 16-bit groups, and one 15-bit group
    // We'll zero-extend the last group to 16 bits for uniformity
    wire [15:0] chunks [15:0];
    genvar i;
    generate
        for(i=0; i<15; i=i+1) begin : chunk_assign
            assign chunks[i] = in[i*16 +: 16];
        end
        // Last chunk: bits 240 to 254 (15 bits), zero-extend MSB
        assign chunks[15] = {1'b0, in[254:240]};
    endgenerate

    // Partial popcounts for each 16-bit chunk
    wire [4:0] partial_popcount [15:0];
    generate
        for(i=0; i<16; i=i+1) begin : popcount16_inst
            popcount16 u_popcount16 (
                .in(chunks[i]),
                .out(partial_popcount[i])
            );
        end
    endgenerate

    // Sum partial counts in a balanced adder tree:
    // Stage 1: 16 inputs (5 bits each) -> 8 sums (6 bits each)
    wire [5:0] sum_stage1 [7:0];
    generate
        for(i=0; i<8; i=i+1) begin : stage1
            assign sum_stage1[i] = partial_popcount[2*i] + partial_popcount[2*i+1];
        end
    endgenerate

    // Stage 2: 8 inputs (6 bits each) -> 4 sums (7 bits each)
    wire [6:0] sum_stage2 [3:0];
    generate
        for(i=0; i<4; i=i+1) begin : stage2
            assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
        end
    endgenerate

    // Stage 3: 4 inputs (7 bits each) -> 2 sums (8 bits each)
    wire [7:0] sum_stage3 [1:0];
    generate
        for(i=0; i<2; i=i+1) begin : stage3
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
        end
    endgenerate

    // Stage 4: 2 inputs (8 bits each) -> 1 sum (9 bits)
    wire [8:0] sum_stage4;
    assign sum_stage4 = sum_stage3[0] + sum_stage3[1];

    // Maximum population count is 255, fits in 8 bits
    assign out = sum_stage4[7:0];
endmodule