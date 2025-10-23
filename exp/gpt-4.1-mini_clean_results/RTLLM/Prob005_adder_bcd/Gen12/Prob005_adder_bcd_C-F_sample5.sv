module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: Perform initial binary addition with carry
    wire [4:0] bin_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Step 2: Efficient BCD overflow detection combining carry and sum bits
    // Overflow if bin_sum > 9:
    // Use condition: Cout = c4 | (c3 & (b2 | b1))
    wire c4 = bin_sum[4];
    wire c3 = bin_sum[3];
    wire b2 = bin_sum[2];
    wire b1 = bin_sum[1];
    wire need_correction = c4 | (c3 & (b2 | b1));

    // Step 3: BCD correction by adding 6 if needed, implemented with combinational logic
    // Correction addition: sum + 6 if overflow, else sum unchanged
    // To avoid a full 5-bit adder for correction, do correction as:
    // corrected_sum = bin_sum + (need_correction ? 6 : 0)
    // Implement addition of 6 using bitwise logic for the lower 4 bits plus carry.
    wire [3:0] raw_sum4 = bin_sum[3:0];
    wire [3:0] correction = 4'b0110; // decimal 6

    // Add correction only if needed, using a small 4-bit adder:
    wire [4:0] corrected_sum_temp = raw_sum4 + (need_correction ? correction : 4'b0000);

    // Final sum lower 4 bits
    assign Sum = corrected_sum_temp[3:0];
    // Carry out is the OR of:
    // - correction carry out (corrected_sum_temp[4])
    // - or the initial carry out from the 5-bit binary sum (bin_sum[4]) if no correction was needed
    // This covers cases where sum > 15 (should not occur in valid BCD inputs) or corrected_sum carry out.
    assign Cout = need_correction ? corrected_sum_temp[4] : c4;

endmodule