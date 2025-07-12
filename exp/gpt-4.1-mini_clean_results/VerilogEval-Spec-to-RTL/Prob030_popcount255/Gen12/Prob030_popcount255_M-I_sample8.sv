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

module popcount32x8 (
    input  [255-1:0] in,
    output [8:0] out  // sum of 32x4-bit counts max 255 fits in 8 bits, use 9 bits to avoid overflow in intermediate sums
);
    // 32 groups of 8 bits
    wire [3:0] partial_counts [31:0];

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : pop8_blocks
            popcount8 u_popcount8 (
                .in(in[8*i +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Last group: only 255 bits total, so last group has 255 - 8*31 = 7 bits, pad with zero at MSB
    wire [7:0] last_group = {1'b0, in[255-1 -: 7]}; // 7 bits plus 1 zero to MSB for popcount8
    popcount8 u_popcount8_last (
        .in(last_group),
        .out(partial_counts[31])
    );

    // Now sum the 32 partial_counts (4-bit each) in a balanced adder tree
    // Level 1: 16 adders, adding pairs of 4-bit counts -> 5-bit sums (max 8+8=16)
    wire [4:0] sum_l1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : l1_adders
            assign sum_l1[i] = partial_counts[2*i] + partial_counts[2*i + 1];
        end
    endgenerate

    // Level 2: 8 adders, adding pairs of 5-bit sums -> 6-bit sums (max 16+16=32)
    wire [5:0] sum_l2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : l2_adders
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i + 1];
        end
    endgenerate

    // Level 3: 4 adders, 6-bit sums -> 7-bit sums (max 32+32=64)
    wire [6:0] sum_l3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : l3_adders
            assign sum_l3[i] = sum_l2[2*i] + sum_l2[2*i + 1];
        end
    endgenerate

    // Level 4: 2 adders, 7-bit sums -> 8-bit sums (max 64+64=128)
    wire [7:0] sum_l4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l4_adders
            assign sum_l4[i] = sum_l3[2*i] + sum_l3[2*i + 1];
        end
    endgenerate

    // Level 5: final adder, 8-bit + 8-bit sums -> 9-bit sum (max 128+128=256 >255 safe)
    assign out = sum_l4[0] + sum_l4[1];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate the popcount32x8 module, discard MSB bit of 9-bit output (can't exceed 255)
    wire [8:0] full_count;

    popcount32x8 u_popcount32x8 (
        .in({in, 1'b0}), // pad input to 256 bits by appending 0 at LSB to simplify indexing
        .out(full_count)
    );

    assign out = full_count[7:0];
endmodule