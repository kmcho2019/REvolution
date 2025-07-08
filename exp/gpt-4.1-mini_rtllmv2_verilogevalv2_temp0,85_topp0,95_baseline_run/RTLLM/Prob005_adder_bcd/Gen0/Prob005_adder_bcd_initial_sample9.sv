module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;      // 5 bits to hold possible carry
    wire [4:0] corrected_sum;
    wire       correction_needed;

    // Step 1: Binary addition of inputs and carry in
    assign binary_sum = A + B + Cin;

    // Step 2: Determine if correction is needed
    // Correction needed if sum > 9 or carry out of 4 bits is set
    assign correction_needed = (binary_sum > 5'd9);

    // Step 3: Add 6 (0110) if correction needed
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Step 4: Output sum is lower 4 bits of corrected sum
    assign Sum = corrected_sum[3:0];

    // Step 5: Carry out is the MSB of corrected sum (bit 4)
    assign Cout = corrected_sum[4];

endmodule