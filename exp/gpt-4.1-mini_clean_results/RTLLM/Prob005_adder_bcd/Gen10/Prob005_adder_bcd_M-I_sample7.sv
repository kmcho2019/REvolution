module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       overflow;

    // Add inputs and carry-in (5 bits for possible carry)
    assign raw_sum = A + B + Cin;

    // Detect overflow for BCD: if raw_sum > 9
    // overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign overflow = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Corrected sum bits: sum + 6 if overflow else sum unchanged.
    // Adding 6 = 0110 binary
    // Implement correction by adding 6 on overflow with simple logic:

    // Bit 0: corrected_sum[0] = raw_sum[0] (since bit0 of 6 is 0)
    wire c0 = raw_sum[0];

    // Bit 1: corrected_sum[1] = raw_sum[1] XOR overflow
    wire c1 = raw_sum[1] ^ overflow;

    // Bit 2: corrected_sum[2] = raw_sum[2] XOR overflow
    wire c2 = raw_sum[2] ^ overflow;

    // Bit 3: corrected_sum[3] = raw_sum[3] XOR overflow
    // Overflow could generate carry from adding 6, so consider carry chain:
    // We'll implement correction addition with carry chain:

    wire c1_carry = raw_sum[1] & overflow;               // carry from bit1
    wire c2_carry = raw_sum[2] & overflow | c1_carry & (raw_sum[2] ^ overflow);
    wire c3 = raw_sum[3] ^ overflow ^ c2_carry;          // corrected bit3
    wire c3_carry = (raw_sum[3] & overflow) | (c2_carry & (raw_sum[3] ^ overflow));

    // Assign Sum and Cout
    assign Sum  = {c3, c2, c1, c0};
    assign Cout = c3_carry | raw_sum[4]; // carry out if correction carry or raw carry

endmodule