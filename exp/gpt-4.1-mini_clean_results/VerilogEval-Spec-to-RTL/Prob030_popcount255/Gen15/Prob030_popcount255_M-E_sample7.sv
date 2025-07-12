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

// Simple unsigned adder module with parameterized width
module addu #(
    parameter WIDTH = 8
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH:0]   sum // one bit wider to avoid overflow
);
    assign sum = a + b;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Pad input to 256 bits by adding a 0 bit at LSB
    wire [255:0] in_padded = {in, 1'b0};

    // Stage 0: Split input into 32 groups of 8 bits, popcount each group
    wire [3:0] pc8 [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i = i +1) begin : popcount8_groups
            popcount8 u_popcount8 (
                .in(in_padded[8*i+7 : 8*i]),
                .out(pc8[i])
            );
        end
    endgenerate

    // Level 1: sum pairs of pc8 outputs (4-bit each), produces 5-bit sums
    wire [4:0] sum1 [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            addu #(.WIDTH(4)) adder_l1 (
                .a(pc8[2*i]),
                .b(pc8[2*i+1]),
                .sum(sum1[i])
            );
        end
    endgenerate

    // Level 2: sum pairs of sum1 outputs (5-bit each), produces 6-bit sums
    wire [5:0] sum2 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2
            addu #(.WIDTH(5)) adder_l2 (
                .a(sum1[2*i]),
                .b(sum1[2*i+1]),
                .sum(sum2[i])
            );
        end
    endgenerate

    // Level 3: sum pairs of sum2 outputs (6-bit each), produces 7-bit sums
    wire [6:0] sum3 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3
            addu #(.WIDTH(6)) adder_l3 (
                .a(sum2[2*i]),
                .b(sum2[2*i+1]),
                .sum(sum3[i])
            );
        end
    endgenerate

    // Level 4: sum pairs of sum3 outputs (7-bit each), produces 8-bit sums
    wire [7:0] sum4 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level4
            addu #(.WIDTH(7)) adder_l4 (
                .a(sum3[2*i]),
                .b(sum3[2*i+1]),
                .sum(sum4[i])
            );
        end
    endgenerate

    // Level 5: sum the two sum4 outputs (8-bit each), produces 9-bit sum
    wire [8:0] sum5;
    addu #(.WIDTH(8)) adder_l5 (
        .a(sum4[0]),
        .b(sum4[1]),
        .sum(sum5)
    );

    // sum5 max value is 255, so output lower 8 bits as final count (safe)
    assign out = sum5[7:0];
endmodule