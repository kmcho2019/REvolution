module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    wire [1:0] half_adder1_sum;
    wire half_adder1_carry;
    wire [1:0] half_adder2_sum;
    wire half_adder2_carry;
    wire carry;

    // Half adder for in[0] and in[1]
    assign half_adder1_sum = in[0] ^ in[1];
    assign half_adder1_carry = in[0] & in[1];

    // Half adder for in[2] and 0 (since we don't need to add anything to in[2])
    assign half_adder2_sum = in[2];
    assign half_adder2_carry = 1'b0;

    // Full adder for half_adder1_sum, half_adder2_sum and half_adder1_carry
    assign out[0] = half_adder1_sum ^ half_adder2_sum;
    assign carry = (half_adder1_sum & half_adder2_sum) | half_adder1_carry;
    assign out[1] = carry;

endmodule