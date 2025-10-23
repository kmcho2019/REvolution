module popcount3(
    input  [2:0] in,
    output [1:0] out  // counts 0..3 ones -> 2 bits
);
    // count bits by adding in[0], in[1], in[2]
    wire [1:0] sum01 = in[0] + in[1]; // 0..2
    wire [2:0] total = sum01 + in[2]; // 0..3
    assign out = total[1:0];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Step 1: Split 255 bits into 85 chunks of 3 bits
    wire [1:0] pc3_out [0:84]; // 85 popcount3 outputs (2 bits each)

    genvar i;
    generate
        for(i=0; i<85; i=i+1) begin : pc3_blocks
            popcount3 pc3_inst (
                .in(in[i*3 +: 3]),
                .out(pc3_out[i])
            );
        end
    endgenerate

    // Level 1: Sum pairs of popcount3 outputs into popcount6 (3 bits)
    // 85 inputs => 42 pairs + 1 leftover (odd number)
    wire [2:0] sumL1 [0:41];
    wire [1:0] leftoverL1 = pc3_out[84];

    integer j;
    always @(*) begin
        for (j=0; j<42; j=j+1) begin
            sumL1[j] = pc3_out[2*j] + pc3_out[2*j+1]; // 2-bit + 2-bit = max 6 => 3 bits
        end
    end

    // Level 2: Sum pairs of Level 1 outputs into popcount12 (4 bits)
    // 42 sums => 21 pairs
    wire [3:0] sumL2 [0:20];
    always @(*) begin
        for (j=0; j<21; j=j+1) begin
            sumL2[j] = sumL1[2*j] + sumL1[2*j+1]; // 3-bit + 3-bit = max 12 => 4 bits
        end
    end

    // Level 3: Sum pairs of Level 2 outputs into popcount24 (5 bits)
    // 21 sums => 10 pairs + 1 leftover
    wire [4:0] sumL3 [0:9];
    wire [3:0] leftoverL3 = sumL2[20];
    always @(*) begin
        for (j=0; j<10; j=j+1) begin
            sumL3[j] = sumL2[2*j] + sumL2[2*j+1]; // 4-bit + 4-bit = max 24 => 5 bits
        end
    end

    // Level 4: Sum pairs of Level 3 outputs into popcount48 (6 bits)
    // 10 sums + leftover (11 total) => 5 pairs + 1 leftover
    wire [5:0] sumL4 [0:4];
    wire [4:0] leftoverL4 = leftoverL3;
    always @(*) begin
        for (j=0; j<5; j=j+1) begin
            sumL4[j] = sumL3[2*j] + sumL3[2*j+1]; // 5-bit + 5-bit = max 48 => 6 bits
        end
    end

    // Level 5: Sum pairs of Level 4 outputs into popcount96 (7 bits)
    // 5 sums + leftover (6 total) => 2 pairs + 1 leftover
    wire [6:0] sumL5 [0:2];
    wire [5:0] leftoverL5 = leftoverL4;
    always @(*) begin
        sumL5[0] = sumL4[0] + sumL4[1]; // 6-bit + 6-bit = max 96 => 7 bits
        sumL5[1] = sumL4[2] + sumL4[3];
        sumL5[2] = {1'b0, sumL4[4]} + {1'b0, leftoverL5}; // zero-extend 6->7 bits and add
    end

    // Level 6: Sum pairs of Level 5 outputs into popcount192 (8 bits)
    // 3 sums => 1 pair + 1 leftover
    wire [7:0] sumL6 [0:1];
    always @(*) begin
        sumL6[0] = sumL5[0] + sumL5[1]; // 7-bit + 7-bit = max 192 => 8 bits
        sumL6[1] = {1'b0, sumL5[2]};    // leftover zero-extended to 8 bits
    end

    // Level 7: Final sum of 2 outputs (max sum = 255 fits in 8 bits)
    assign out = sumL6[0] + sumL6[1];

endmodule