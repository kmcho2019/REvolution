module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // First: binary addition of inputs
    wire [4:0] bin_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Detect if correction needed (sum > 9)
    // Condition: sum[4] (carry out) is 1 OR sum[3] & (sum[2] | sum[1])
    wire need_correction = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // Precompute corrected sum bits (bin_sum + 6) without full adder:
    // Adding 6 (0110) to bin_sum[3:0]:
    // sum + 6:
    // bit0_corrected = sum[0] (since 6's bit0=0, bit0 just remains sum[0])
    // bit1_corrected = ~sum[1]
    // bit2_corrected = sum[2] ^ sum[1]
    // bit3_corrected = 1

    // Let's compute:
    wire c0 = bin_sum[0];
    wire c1 = bin_sum[1];
    wire c2 = bin_sum[2];
    wire c3 = bin_sum[3];

    // From binary addition with 6=0110:
    // Add bit0: sum[0] + 0 = sum[0]
    // Add bit1: sum[1] + 1 + carry from bit0
    // Carry from bit0 is 0 since adding 0
    // So bit1_corrected = sum[1] + 1 = ~sum[1], carry to bit2 is sum[1]
    // bit2_corrected = sum[2] + 1 (carry from bit1) + carry from bit1 addition
    // Implemented as sum[2]^sum[1] (xor)
    // bit3_corrected = sum[3] + carry from bit2 addition. For BCD digits, bit3_corrected = 1

    // For correctness and simplicity, use classic known logic from literature:

    wire [3:0] corrected_sum = {
        1'b1,              // bit3 corrected always 1 (due to adding 6)
        ~(c1),             // bit1 corrected is NOT sum[1]
        c2 ^ c1,           // bit2 corrected is sum[2] XOR sum[1]
        c0                 // bit0 corrected is sum[0]
    };

    // Output mux between corrected sum and original sum
    assign Sum = need_correction ? corrected_sum : bin_sum[3:0];
    assign Cout = need_correction;

endmodule