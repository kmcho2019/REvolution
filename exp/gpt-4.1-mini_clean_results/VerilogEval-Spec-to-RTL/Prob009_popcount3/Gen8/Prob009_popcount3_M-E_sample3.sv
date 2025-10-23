module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire sum1_sum, sum1_carry;
    wire sum2_sum, sum2_carry;

    // Half adder for in[0] and in[1]
    assign sum1_sum   = in[0] ^ in[1];
    assign sum1_carry = in[0] & in[1];

    // Full adder for sum1_sum, in[2], and sum1_carry
    assign sum2_sum   = sum1_sum ^ in[2] ^ sum1_carry;
    assign sum2_carry = (sum1_sum & in[2]) | (sum1_sum & sum1_carry) | (in[2] & sum1_carry);

    assign out = {sum2_carry, sum2_sum};

endmodule