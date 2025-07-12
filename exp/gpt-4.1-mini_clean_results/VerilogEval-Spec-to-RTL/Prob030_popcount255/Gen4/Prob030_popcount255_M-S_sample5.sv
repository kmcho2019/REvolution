module popcount8 (
    input  [7:0] in,
    output [4:0] out  // max 8 ones, 4 bits enough, 5 bits for safety in sums
);
    // Count bits by adding groups of bits explicitly
    wire [2:0] sum01 = in[0] + in[1] + in[2];
    wire [2:0] sum23 = in[3] + in[4] + in[5];
    wire [1:0] sum45 = in[6] + in[7];
    wire [4:0] total = sum01 + sum23 + sum45;
    assign out = total;
endmodule

module popcount7 (
    input  [6:0] in,
    output [4:0] out  // max 7 ones
);
    // Count bits by adding groups of bits explicitly
    wire [2:0] sum01 = in[0] + in[1] + in[2];
    wire [2:0] sum23 = in[3] + in[4] + in[5];
    wire [1:0] sum6  = in[6];
    wire [4:0] total = sum01 + sum23 + sum6;
    assign out = total;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 31 groups of 8 bits and 1 group of 7 bits: total 32 groups
    wire [4:0] partial_counts [31:0];

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : pc8_blocks
            popcount8 pc8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
        popcount7 pc7 (
            .in(in[31*8 +: 7]),
            .out(partial_counts[31])
        );
    endgenerate

    // Sum all 32 partial counts (each max 8) using a balanced adder tree
    // Level 1: 16 sums of pairs (5 bits + 5 bits = up to 16, needs 6 bits)
    wire [6:0] sum_l1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            assign sum_l1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Level 2: 8 sums of pairs (7 bits + 7 bits = up to 32, needs 8 bits)
    wire [7:0] sum_l2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    // Level 3: 4 sums of pairs (8 bits + 8 bits = up to 64, needs 8 bits)
    wire [7:0] sum_l3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3
            assign sum_l3[i] = sum_l2[2*i] + sum_l2[2*i+1];
        end
    endgenerate

    // Level 4: 2 sums of pairs (8 bits + 8 bits = up to 128, 8 bits enough)
    wire [7:0] sum_l4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level4
            assign sum_l4[i] = sum_l3[2*i] + sum_l3[2*i+1];
        end
    endgenerate

    // Level 5: final sum (8 bits + 8 bits = up to 255)
    assign out = sum_l4[0] + sum_l4[1];

endmodule