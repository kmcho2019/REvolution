module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;        // Sum of A, B, and Cin (5 bits for carry)
    wire       correction;     // Correction needed flag
    wire [4:0] sum_plus_6;    // Sum after adding correction (if needed)
    wire [4:0] corrected_sum; // Corrected sum output

    // Step 1: Add inputs with carry-in
    assign raw_sum = A + B + Cin;

    // Step 2: Determine if correction is needed
    // correction if raw_sum > 9 (decimal)
    // Implement condition explicitly:
    // raw_sum[4] == 1 (means sum >= 16) -> correction needed
    // OR (raw_sum[3] & raw_sum[2]) == 1 (sum >= 12)
    // OR (raw_sum[3] & raw_sum[1]) == 1 (sum >= 10)
    assign correction = raw_sum[4] | (raw_sum[3] & raw_sum[2]) | (raw_sum[3] & raw_sum[1]);

    // Step 3: Add 6 if correction needed
    assign sum_plus_6 = raw_sum + 5'd6;

    // Step 4: Select corrected sum or raw sum based on correction
    assign corrected_sum = correction ? sum_plus_6 : raw_sum;

    // Output sum is lower 4 bits
    assign Sum = corrected_sum[3:0];

    // Carry out is MSB of corrected sum (bit 4)
    assign Cout = corrected_sum[4];

endmodule