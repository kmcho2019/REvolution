module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Explicit popcount by summing bits without loops or behavioral code
    wire [2:0] sum_lo = in[0] + in[1] + in[2] + in[3]; // max 4, needs 3 bits
    wire [2:0] sum_hi = in[4] + in[5] + in[6] + in[7]; // max 4, needs 3 bits
    assign out = sum_lo + sum_hi; // 3-bit + 3-bit = 4-bit sum (max 8)
endmodule

module popcount16 (
    input  [15:0] in,
    output [4:0] out // max 16 ones fits in 5 bits
);
    // Popcount16 by combining two popcount8 modules plus one 5-bit adder
    wire [3:0] low_count, high_count;

    popcount8 pc_low  (.in(in[7:0]),  .out(low_count));
    popcount8 pc_high (.in(in[15:8]), .out(high_count));

    assign out = low_count + high_count; // 4-bit + 4-bit = 5-bit sum
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Divide input into 16 groups of 16 bits (last padded with zero)
    // Use popcount16 for each group, then sum all 16 partial counts in balanced tree

    wire [4:0] partial_counts [15:0]; // 5-bit count per 16-bit group (max 16)

    // Group 0 to 14 (full 16 bits each)
    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : gen_popcount16_groups
            popcount16 pc16_inst (
                .in(in[(i*16)+15 : i*16]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Group 15 (last 15 bits + 1 padded zero MSB)
    wire [15:0] last_group = {1'b0, in[254:240]};
    popcount16 pc16_last (
        .in(last_group),
        .out(partial_counts[15])
    );

    // Balanced binary tree summation of the 16 partial_counts (each 5 bits)

    // Level 1: sum pairs -> 6 bits max (16+16=32 max)
    wire [5:0] sum_l1 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_sum_l1
            assign sum_l1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs -> 7 bits max (32+32=64 max)
    wire [6:0] sum_l2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_sum_l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs -> 8 bits max (64+64=128 max)
    wire [7:0] sum_l3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_sum_l3
            assign sum_l3[i] = sum_l2[2*i] + sum_l2[2*i+1];
        end
    endgenerate

    // Level 4: final sum -> 8 bits max (128+128=256 max, fits 8 bits with max 255)
    assign out = sum_l3[0] + sum_l3[1];

endmodule