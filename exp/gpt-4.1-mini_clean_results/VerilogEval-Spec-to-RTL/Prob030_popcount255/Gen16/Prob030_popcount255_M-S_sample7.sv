module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);

    // Step 1: Sum bits in chunks of 8 (except last chunk which has 255 - 31*8 = 255-248=7 bits)
    // 31 chunks of 8 bits = 248 bits, plus 1 chunk of 7 bits = total 255 bits

    // Partial sums: 32 values (31 of 8 bits, 1 of 7 bits)
    wire [7:0] partial_sum [0:31];

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : chunk8
            assign partial_sum[i] = 
                in[i*8 +: 8][0] + in[i*8 +: 8][1] + in[i*8 +: 8][2] + in[i*8 +: 8][3] +
                in[i*8 +: 8][4] + in[i*8 +: 8][5] + in[i*8 +: 8][6] + in[i*8 +: 8][7];
        end
    endgenerate

    // Last chunk of 7 bits
    assign partial_sum[31] = 
        in[248] + in[249] + in[250] + in[251] + in[252] + in[253] + in[254];

    // Step 2: Sum partial sums two by two
    // Reduce 32 values -> 16
    wire [8:0] sum16 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_pair1
            assign sum16[i] = partial_sum[2*i] + partial_sum[2*i+1];
        end
    endgenerate

    // Step 3: Sum 16 values two by two -> 8
    wire [9:0] sum8 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_pair2
            assign sum8[i] = sum16[2*i] + sum16[2*i+1];
        end
    endgenerate

    // Step 4: Sum 8 values two by two -> 4
    wire [10:0] sum4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_pair3
            assign sum4[i] = sum8[2*i] + sum8[2*i+1];
        end
    endgenerate

    // Step 5: Sum 4 values two by two -> 2
    wire [11:0] sum2 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_pair4
            assign sum2[i] = sum4[2*i] + sum4[2*i+1];
        end
    endgenerate

    // Step 6: Sum the final two values
    wire [12:0] total_sum = sum2[0] + sum2[1];

    // Output the lowest 8 bits (max sum is 255, fits 8 bits)
    assign out = total_sum[7:0];

endmodule