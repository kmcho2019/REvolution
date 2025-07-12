module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    // Bitwise XOR operations to generate sum bits
    wire [3:0] sum_bits;
    assign sum_bits[0] = x[0] ^ y[0];
    assign sum_bits[1] = x[1] ^ y[1];
    assign sum_bits[2] = x[2] ^ y[2];
    assign sum_bits[3] = x[3] ^ y[3];

    // Bitwise AND operations to generate carry bits
    wire [3:0] carry_bits;
    assign carry_bits[0] = x[0] & y[0];
    assign carry_bits[1] = x[1] & y[1];
    assign carry_bits[2] = x[2] & y[2];
    assign carry_bits[3] = x[3] & y[3];

    // Accumulate carry bits
    wire [2:0] accumulated_carry;
    assign accumulated_carry[0] = carry_bits[0];
    assign accumulated_carry[1] = carry_bits[1] | (carry_bits[0] & sum_bits[1]);
    assign accumulated_carry[2] = carry_bits[2] | (carry_bits[1] & sum_bits[2]) | (carry_bits[0] & sum_bits[1] & sum_bits[2]);

    // Add accumulated carry bits to sum bits
    assign sum[0] = sum_bits[0];
    assign sum[1] = sum_bits[1] ^ accumulated_carry[0];
    assign sum[2] = sum_bits[2] ^ accumulated_carry[1];
    assign sum[3] = sum_bits[3] ^ accumulated_carry[2];
    assign sum[4] = carry_bits[3] | (carry_bits[2] & sum_bits[3]) | (carry_bits[1] & sum_bits[2] & sum_bits[3]) | (carry_bits[0] & sum_bits[1] & sum_bits[2] & sum_bits[3]);

endmodule