module popcount8 (
    input  [7:0] in,
    output [4:0] out  // max 8 ones, need 4 bits, 5 bits for safety
);
    // Balanced tree addition of 8 bits
    wire [3:0] sum_level1; // sum pairs of bits (2-bit results)
    assign sum_level1[0] = in[0] + in[1];
    assign sum_level1[1] = in[2] + in[3];
    assign sum_level1[2] = in[4] + in[5];
    assign sum_level1[3] = in[6] + in[7];

    wire [4:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    assign out = sum_level2[0] + sum_level2[1];
endmodule


module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones => 5 bits needed, use 6 bits safely
);
    wire [4:0] pc8_0;
    wire [4:0] pc8_1;

    // Count first 8 bits
    popcount8 pc8_low (
        .in(in[7:0]),
        .out(pc8_0)
    );

    // Count next 8 bits
    popcount8 pc8_high (
        .in(in[15:8]),
        .out(pc8_1)
    );

    // Add the two 5-bit counts and leftover 1 bit
    wire [5:0] sum8_0_1 = pc8_0 + pc8_1; // max 8+8=16 fits 5 bits, sum in 6 bits safely
    assign out = sum8_0_1 + in[16];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 15 groups of 17 bits (15*17=255)
    wire [5:0] partial_counts [14:0]; // 15 partial counts

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Sum 15 partial counts (each max 17) into one 8-bit output
    // Max sum = 15 * 17 = 255 fits in 8 bits

    // Level 1: sum pairs of partial_counts (7 pairs + 1 leftover)
    wire [7:0] sum_level1 [7:0];
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
        assign sum_level1[7] = {2'b00, partial_counts[14]}; // zero-extend to 8 bits
    endgenerate

    // Level 2: sum pairs of sum_level1 outputs (8 inputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 outputs (4 inputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum final two outputs (2 inputs)
    assign out = sum_level3[0] + sum_level3[1];

endmodule