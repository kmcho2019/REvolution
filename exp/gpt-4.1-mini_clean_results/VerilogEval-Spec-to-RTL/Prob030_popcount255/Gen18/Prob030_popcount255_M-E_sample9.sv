module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced adder tree for 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out // max count 7 fits in 3 bits but use 4 for consistency
);
    // Balanced adder tree for 7 bits
    // pad with 0 for one bit to form 8 bits and reuse popcount8
    wire [7:0] in_padded = {1'b0, in};
    popcount8 u_popcount8 (
        .in(in_padded),
        .out(out)
    );
endmodule

module adder_width #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH:0] sum // output width = WIDTH+1 for carry
);
    assign sum = a + b;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Break input into 31 chunks of 8 bits and 1 chunk of 7 bits
    // Partial popcounts: 31 * 4-bit + 1 * 4-bit = 32 partial sums

    // Stage 1: partial counts
    wire [3:0] partial_counts [31:0];
    genvar i;

    generate
        // 31 chunks of 8 bits
        for(i=0; i<31; i=i+1) begin : gen_popcount8_chunks
            popcount8 u_popcount8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Last 7-bit chunk (bits 248 to 254)
    popcount7 u_popcount7 (
        .in(in[254:248]),
        .out(partial_counts[31])
    );

    // Stage 2: balanced adder tree of partial sums to get final output
    // Each partial_counts[i] is 4 bits max (0 to 8).
    // Sum 32 4-bit numbers -> max sum = 255 requires 8 bits.

    // We'll build a 5-level balanced adder tree:
    // Level 0: 32 inputs (4-bit each)
    // Level 1: 16 sums (5-bit each)
    // Level 2: 8 sums (6-bit each)
    // Level 3: 4 sums (7-bit each)
    // Level 4: 2 sums (8-bit each)
    // Level 5: 1 sum (9-bit), but max is 255 so 8 bits suffice

    // Level 1: sum pairs of 4-bit inputs -> output width 5 bits
    wire [4:0] level1 [15:0];
    generate
        for(i=0; i<16; i=i+1) begin : gen_level1_adders
            adder_width #(.WIDTH(4)) adder (
                .a(partial_counts[2*i]),
                .b(partial_counts[2*i+1]),
                .sum(level1[i])
            );
        end
    endgenerate

    // Level 2: sum pairs of 5-bit inputs -> output width 6 bits
    wire [5:0] level2 [7:0];
    generate
        for(i=0; i<8; i=i+1) begin : gen_level2_adders
            adder_width #(.WIDTH(5)) adder (
                .a(level1[2*i]),
                .b(level1[2*i+1]),
                .sum(level2[i])
            );
        end
    endgenerate

    // Level 3: sum pairs of 6-bit inputs -> output width 7 bits
    wire [6:0] level3 [3:0];
    generate
        for(i=0; i<4; i=i+1) begin : gen_level3_adders
            adder_width #(.WIDTH(6)) adder (
                .a(level2[2*i]),
                .b(level2[2*i+1]),
                .sum(level3[i])
            );
        end
    endgenerate

    // Level 4: sum pairs of 7-bit inputs -> output width 8 bits
    wire [7:0] level4 [1:0];
    generate
        for(i=0; i<2; i=i+1) begin : gen_level4_adders
            adder_width #(.WIDTH(7)) adder (
                .a(level3[2*i]),
                .b(level3[2*i+1]),
                .sum(level4[i])
            );
        end
    endgenerate

    // Level 5: sum the last two 8-bit inputs -> output width 9 bits but max sum is 255
    wire [8:0] level5_sum;
    adder_width #(.WIDTH(8)) adder_final (
        .a(level4[0]),
        .b(level4[1]),
        .sum(level5_sum)
    );

    // Assign final output: level5_sum max 9 bits, max value 255 fits in 8 bits, so discard MSB
    assign out = level5_sum[7:0];

endmodule