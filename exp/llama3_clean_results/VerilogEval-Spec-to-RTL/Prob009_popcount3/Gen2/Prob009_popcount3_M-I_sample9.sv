module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] half_adder_sum;
    wire half_adder_carry;

    // Half adder for in[0] and in[1]
    assign half_adder_sum[0] = in[0] ^ in[1];
    assign half_adder_carry = in[0] & in[1];

    // Full adder for half_adder_sum, half_adder_carry, and in[2]
    assign out[0] = half_adder_sum[0] ^ in[2];
    assign out[1] = half_adder_carry ^ (half_adder_sum[0] & in[2]);

endmodule