module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Extend input to 256 bits by padding LSB with zero
    wire [255:0] in_padded = {in, 1'b0};

    // Instantiate 32 popcount8 blocks to process each 8-bit chunk
    wire [3:0] partial_counts [31:0];

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : pop8_blocks
            popcount8 u_pop8 (
                .in(in_padded[8*i +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Sum the 32 partial counts in stages
    // Stage 1: sum pairs -> 16 sums of 5 bits max (max 16)
    wire [4:0] sum_stage1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum1
            assign sum_stage1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Stage 2: sum pairs -> 8 sums of 6 bits max (max 32)
    wire [5:0] sum_stage2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum2
            assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs -> 4 sums of 7 bits max (max 64)
    wire [6:0] sum_stage3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum3
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
        end
    endgenerate

    // Stage 4: sum pairs -> 2 sums of 8 bits max (max 128)
    wire [7:0] sum_stage4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum4
            assign sum_stage4[i] = sum_stage3[2*i] + sum_stage3[2*i+1];
        end
    endgenerate

    // Stage 5: final sum -> 8 bits max (max 255)
    wire [7:0] sum_final = sum_stage4[0] + sum_stage4[1];

    assign out = sum_final;
endmodule