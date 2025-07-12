module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    // First stage: calculate the sum and carry bits
    wire [3:0] sum_bits;
    wire [3:0] carry_bits;

    assign sum_bits[0] = x[0] ^ y[0];
    assign carry_bits[0] = x[0] & y[0];

    assign sum_bits[1] = x[1] ^ y[1];
    assign carry_bits[1] = x[1] & y[1];

    assign sum_bits[2] = x[2] ^ y[2];
    assign carry_bits[2] = x[2] & y[2];

    assign sum_bits[3] = x[3] ^ y[3];
    assign carry_bits[3] = x[3] & y[3];

    // Second stage: calculate the final sum bits using a ripple-carry adder
    assign sum[0] = sum_bits[0];
    assign sum[1] = sum_bits[1] ^ carry_bits[0];
    assign sum[2] = sum_bits[2] ^ (carry_bits[1] | (carry_bits[0] & sum_bits[1]));
    assign sum[3] = sum_bits[3] ^ (carry_bits[2] | (carry_bits[1] & sum_bits[2]) | (carry_bits[0] & sum_bits[1] & sum_bits[2]));
    assign sum[4] = carry_bits[3] | (carry_bits[2] & sum_bits[3]) | (carry_bits[1] & sum_bits[2] & sum_bits[3]) | (carry_bits[0] & sum_bits[1] & sum_bits[2] & sum_bits[3]);

endmodule