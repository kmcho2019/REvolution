module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
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

module popcount7 (
    input  [6:0] in,
    output [3:0] out // max count 7 fits in 3 bits, but 4 bits for consistency
);
    // Similar adder tree but only 7 bits
    wire [1:0] sum_l1 [3:0];
    assign sum_l1[0] = in[0] + in[1];
    assign sum_l1[1] = in[2] + in[3];
    assign sum_l1[2] = in[4] + in[5];
    assign sum_l1[3] = in[6] + 1'b0; // pad 0

    wire [2:0] sum_l2 [1:0];
    assign sum_l2[0] = sum_l1[0] + sum_l1[1];
    assign sum_l2[1] = sum_l1[2] + sum_l1[3];

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Divide input into 32 groups of 8 bits + 1 group of 7 bits
    wire [3:0] counts_8 [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : pc8_blocks
            popcount8 u_popcount8 (
                .in(in[i*8 +: 8]),
                .out(counts_8[i])
            );
        end
    endgenerate

    wire [3:0] count_7;
    popcount7 u_popcount7 (
        .in(in[254:248]),
        .out(count_7)
    );

    // Sum all partial counts: 32 counts_8 and 1 count_7 = 33 counts, each max 8 (4 bits)
    // Max total = 255 -> needs 8 bits output

    // Level 1: sum pairs of counts (16 sums)
    wire [4:0] sum_l1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_level1
            assign sum_l1[i] = counts_8[2*i] + counts_8[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs of sums (8 sums)
    wire [5:0] sum_l2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_level2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sums (4 sums)
    wire [6:0] sum_l3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_level3
            assign sum_l3[i] = sum_l2[2*i] + sum_l2[2*i+1];
        end
    endgenerate

    // Level 4: sum pairs of sums (2 sums)
    wire [7:0] sum_l4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_level4
            assign sum_l4[i] = sum_l3[2*i] + sum_l3[2*i+1];
        end
    endgenerate

    // Level 5: sum last two and add count_7 (extend count_7 to 8 bits)
    wire [7:0] count_7_ext = {4'b0, count_7};
    assign out = sum_l4[0] + sum_l4[1] + count_7_ext;

endmodule