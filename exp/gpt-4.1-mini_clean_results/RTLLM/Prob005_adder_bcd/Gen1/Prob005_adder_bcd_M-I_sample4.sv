module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;

    // Correction needed if carry out set or sum > 9
    // Condition: correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Adding 6 (0110) if correction needed without full adder for correction:
    // sum + 6 correction:
    // Bit0: same as raw_sum[0]
    // Bit1: raw_sum[1] xor correction_needed (adding 1)
    // Bit2: raw_sum[2] xor correction_needed (adding 1)
    // Bit3: raw_sum[3] xor correction_needed (adding 0)
    // Carry out from correction addition corresponds to Cout

    wire c1 = raw_sum[0] & correction_needed; // carry from bit0 after adding 0
    wire b1 = raw_sum[1] ^ correction_needed ^ c1;
    wire c2 = (raw_sum[1] & correction_needed) | (raw_sum[1] & c1) | (correction_needed & c1);
    wire b2 = raw_sum[2] ^ c2;
    wire c3 = raw_sum[2] & c2;
    wire b3 = raw_sum[3] ^ c3;
    wire cout_internal = raw_sum[4] | (b3 & c3); // carry out after correction

    assign Sum = {b3, b2, b1, raw_sum[0]};
    assign Cout = correction_needed;

endmodule