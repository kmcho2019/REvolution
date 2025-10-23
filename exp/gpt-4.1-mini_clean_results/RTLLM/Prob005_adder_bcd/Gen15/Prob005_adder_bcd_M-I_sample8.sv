module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: Binary addition of inputs plus carry-in (5 bits to include carry)
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Detect if correction needed (sum > 9)
    // correction_needed if MSB set or bits[3] & (bits[2] | bits[1]) set
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Correct sum by adding 6 (0110) if needed, else pass raw_sum unchanged
    wire [4:0] corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Carry out is the MSB of corrected_sum (carry beyond 4 bits)
    assign Cout = corrected_sum[4];

endmodule