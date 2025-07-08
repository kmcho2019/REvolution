module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Step 1: Binary addition of A, B and Cin
    assign binary_sum = A + B + Cin;

    // Step 2: Determine if correction is needed
    // Correction needed if sum > 9 or if there is a carry out from 4 bits
    assign correction_needed = (binary_sum > 5'd9);

    // Step 3: If correction is needed, add 6 (0110) to binary_sum
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Step 4: Output the lower 4 bits as Sum and the carry out as Cout
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule