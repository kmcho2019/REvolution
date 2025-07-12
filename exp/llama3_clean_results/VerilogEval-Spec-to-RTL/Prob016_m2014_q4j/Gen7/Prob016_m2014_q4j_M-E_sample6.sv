// 2-bit adder module
module TwoBitAdder(
    input   logic [1:0] a,
    input   logic [1:0] b,
    output  logic [2:0] sum
);

    logic carry;

    assign sum[0] = a[0] ^ b[0];
    assign sum[1] = a[1] ^ b[1];
    assign carry = (a[0] & b[0]) | (a[0] & sum[1]) | (b[0] & sum[1]);
    assign sum[2] = carry;

endmodule

// TopModule using the split-digit adder concept
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    logic [2:0] low_sum, high_sum;
    logic carry_to_high;

    // Low segment (bits 0-1)
    TwoBitAdder low_adder(
        .a(x[1:0]),
        .b(y[1:0]),
        .sum(low_sum)
    );

    // High segment (bits 2-3)
    TwoBitAdder high_adder(
        .a(x[3:2]),
        .b(y[3:2]),
        .sum(high_sum)
    );

    // Handle carry between segments
    assign carry_to_high = low_sum[2];

    // Combine segment sums and carry
    assign sum[0] = low_sum[0];
    assign sum[1] = low_sum[1];
    assign sum[2] = high_sum[0] ^ carry_to_high;
    assign sum[3] = high_sum[1];
    assign sum[4] = high_sum[2] | (high_sum[1] & carry_to_high);

endmodule