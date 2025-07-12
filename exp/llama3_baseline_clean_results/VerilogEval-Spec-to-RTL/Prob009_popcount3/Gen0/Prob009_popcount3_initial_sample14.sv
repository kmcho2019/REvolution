module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Half adder for in[0] and in[1]
    wire sum_0, carry_0;
    half_adder ha_0(in[0], in[1], sum_0, carry_0);

    // Half adder for in[2] and sum_0
    wire sum_1, carry_1;
    half_adder ha_1(in[2], sum_0, sum_1, carry_1);

    // Full adder for carry_0, carry_1, and sum_1
    wire out_sum, out_carry;
    full_adder fa_0(carry_0, carry_1, sum_1, out_sum, out_carry);

    // Output assignment
    assign out[0] = out_sum;
    assign out[1] = out_carry;

endmodule

module half_adder(
    input a,
    input b,
    output sum,
    output carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

module full_adder(
    input a,
    input b,
    input c_in,
    output sum,
    output carry
);
    assign sum = a ^ b ^ c_in;
    assign carry = (a & b) | (a & c_in) | (b & c_in);
endmodule