module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones => 5 bits enough, use 6 bits for safety
);
    // Simple summation by a for loop unrolled manually
    // Summing 17 bits into a 6-bit output
    integer i;
    reg [5:0] sum;
    always @(*) begin
        sum = 0;
        for(i=0; i<17; i=i+1) sum = sum + in[i];
    end
    assign out = sum;
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

    // Now sum 15 partial counts (each max 17) into one 8-bit output
    // Max sum = 15 * 17 = 255 fits in 8 bits

    // Sum partial_counts in a balanced adder tree manner:

    wire [7:0] sum_level1 [7:0];
    genvar i;

    // Level 1: sum pairs of partial_counts
    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
        // Last one (15th) passes through
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