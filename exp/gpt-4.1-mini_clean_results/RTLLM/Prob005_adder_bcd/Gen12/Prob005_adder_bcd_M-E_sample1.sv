module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       corr_bit3, corr_bit2, corr_bit1, corr_bit0;
    wire [4:0] correction;
    wire [4:0] corrected_sum;

    // Step 1: Perform 5-bit binary addition of inputs and carry-in
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Generate correction bits based on raw_sum bits (4 downto 0)
    // Correction needed if sum > 9 (1001)
    // Using combinational logic to generate correction nibble (0x6) or zero

    // Correction bit 3 (MSB of correction nibble) is 0 in correction (6 = 0110)
    assign corr_bit3 = 1'b0;

    // Correction bit 2 is 1 if correction needed (sum > 9)
    // condition: raw_sum[4] == 1 OR (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    assign corr_bit2 = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Correction bit 1 is also set when correction needed
    assign corr_bit1 = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Correction bit 0 is 0 in correction (6 = 0110)
    assign corr_bit0 = 1'b0;

    assign correction = {corr_bit3, corr_bit2, corr_bit1, corr_bit0};

    // Step 3: Add correction to raw_sum (correction zero-extended to 5 bits)
    assign corrected_sum = raw_sum + {1'b0, correction};

    // Step 4: Outputs
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule