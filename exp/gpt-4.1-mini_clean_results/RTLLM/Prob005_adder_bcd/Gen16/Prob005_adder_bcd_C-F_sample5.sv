module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Step 1: Raw 4-bit binary addition with carry-out (5 bits)
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Correction detection
    // Correction needed if raw_sum > 9:
    // condition: raw_sum[4] == 1 OR (raw_sum[3] & (raw_sum[2] | raw_sum[1]))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Prepare correction addition inputs
    wire [3:0] sum_low = raw_sum[3:0];
    wire [3:0] correction = 4'b0110; // decimal 6

    // Step 4: Add correction only if needed
    // Use a small 4-bit adder with carry propagate logic to add correction and sum_low
    wire [3:0] corrected_sum;
    wire       correction_carry_out;

    // Carry signals for the addition bits
    wire c0 = 1'b0;
    wire c1, c2, c3;

    // Bit 0 addition
    assign corrected_sum[0] = sum_low[0] ^ (correction_needed & correction[0]) ^ c0;
    assign c1 = (sum_low[0] & (correction_needed & correction[0])) | ((sum_low[0] ^ (correction_needed & correction[0])) & c0);

    // Bit 1 addition
    assign corrected_sum[1] = sum_low[1] ^ (correction_needed & correction[1]) ^ c1;
    assign c2 = (sum_low[1] & (correction_needed & correction[1])) | ((sum_low[1] ^ (correction_needed & correction[1])) & c1);

    // Bit 2 addition
    assign corrected_sum[2] = sum_low[2] ^ (correction_needed & correction[2]) ^ c2;
    assign c3 = (sum_low[2] & (correction_needed & correction[2])) | ((sum_low[2] ^ (correction_needed & correction[2])) & c2);

    // Bit 3 addition
    assign corrected_sum[3] = sum_low[3] ^ (correction_needed & correction[3]) ^ c3;
    assign correction_carry_out = (sum_low[3] & (correction_needed & correction[3])) | ((sum_low[3] ^ (correction_needed & correction[3])) & c3);

    // Step 5: Select final sum and generate carry out
    // If correction needed, use corrected_sum else raw sum low bits
    assign Sum = correction_needed ? corrected_sum : sum_low;

    // Carry out is either raw_sum's MSB or the carry from correction addition
    assign Cout = raw_sum[4] | correction_carry_out;

endmodule