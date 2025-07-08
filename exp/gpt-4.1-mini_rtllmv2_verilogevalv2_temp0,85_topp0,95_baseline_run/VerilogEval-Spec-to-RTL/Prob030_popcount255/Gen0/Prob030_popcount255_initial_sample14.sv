module TopModule(
    input  wire [254:0] in,
    output wire [7:0] out
);

// First, split the input into smaller chunks and count bits in each chunk
// We'll use a tree of adders to accumulate counts

// Count bits in groups of 3 (except the last one which has 0 bits to pad to 255 bits)
wire [7:0] sum3 [84:0]; // 85 groups of 3 bits each (85*3=255)

// Assign each group of 3 bits to sum3
genvar i;
generate
    for(i=0; i<85; i=i+1) begin : group3
        wire [2:0] chunk;
        assign chunk = in[i*3 +: 3];
        // Count the number of 1's in chunk (3 bits)
        // Using a small adder for population count of 3 bits
        assign sum3[i] = (chunk[0] ? 1 : 0) + (chunk[1] ? 1 : 0) + (chunk[2] ? 1 : 0);
    end
endgenerate

// Now sum all sum3[0..84] values (each 0 to 3) into one 8-bit number
// We'll do it hierarchically by summing pairs repeatedly

// Stage 1: sum3 has 85 values (0..84 indices). Sum pairs to get sum_stage1 with 43 values + 1 leftover
wire [8:0] sum_stage1 [42:0]; // 43 sums (each sum of two 8-bit numbers max 6 bits but safe to use 9 bits)
generate
    for(i=0; i<42; i=i+1) begin : stage1_pairs
        assign sum_stage1[i] = sum3[2*i] + sum3[2*i+1];
    end
    // leftover sum3[84]
    assign sum_stage1[42] = sum3[84];
endgenerate

// Stage 2: sum_stage1 has 43 values. Sum pairs to get sum_stage2 with 21 values + 1 leftover
wire [9:0] sum_stage2 [20:0];
generate
    for(i=0; i<21; i=i+1) begin : stage2_pairs
        assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
    end
    // leftover sum_stage1[42]
    assign sum_stage2[20] = sum_stage1[42];
endgenerate

// Stage 3: sum_stage2 has 21 values. Sum pairs to get sum_stage3 with 10 values + 1 leftover
wire [10:0] sum_stage3 [9:0];
generate
    for(i=0; i<10; i=i+1) begin : stage3_pairs
        assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
    end
    // leftover sum_stage2[20]
    assign sum_stage3[10] = sum_stage2[20];
endgenerate

// Wait, sum_stage3 defined with 10 elements but we access 11 (indices 0..10)
// Fix: sum_stage3 should be [10:0] to hold 11 elements
wire [10:0] sum_stage3 [10:0];
generate
    for(i=0; i<10; i=i+1) begin : stage3_pairs_fixed
        assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
    end
    assign sum_stage3[10] = sum_stage2[20];
endgenerate

// Stage 4: sum_stage3 has 11 values. Sum pairs to get sum_stage4 with 5 values + 1 leftover
wire [11:0] sum_stage4 [5:0];
generate
    for(i=0; i<5; i=i+1) begin : stage4_pairs
        assign sum_stage4[i] = sum_stage3[2*i] + sum_stage3[2*i+1];
    end
    // leftover sum_stage3[10]
    assign sum_stage4[5] = sum_stage3[10];
endgenerate

// Stage 5: sum_stage4 has 6 values. Sum pairs to get sum_stage5 with 3 values
wire [12:0] sum_stage5 [2:0];
generate
    for(i=0; i<2; i=i+1) begin : stage5_pairs
        assign sum_stage5[i] = sum_stage4[2*i] + sum_stage4[2*i+1];
    end
    // leftover sum_stage4[5]
    assign sum_stage5[2] = sum_stage4[5];
endgenerate

// Stage 6: sum_stage5 has 3 values. Sum first two, then add last one
wire [13:0] sum_stage6_0 = sum_stage5[0] + sum_stage5[1];
wire [14:0] total_sum = sum_stage6_0 + sum_stage5[2];

// total_sum is the total population count, max 255, fits in 8 bits
assign out = total_sum[7:0];

endmodule