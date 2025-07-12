module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] binary_sum;
    wire       correction_needed;

    // Perform initial binary addition of A, B and Cin
    assign binary_sum = A + B + Cin;

    // Determine if correction needed (sum > 9)
    // Condition: carry out from binary addition OR sum > 9 (1001)
    assign correction_needed = binary_sum[4] | 
                               (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Generate corrected sum: if correction_needed add 6 (0110) else pass through binary_sum
    wire [4:0] corrected_sum;
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Output Sum is the lower 4 bits of corrected_sum
    assign Sum  = corrected_sum[3:0];
    // Output Cout is the carry-out bit after correction
    assign Cout = corrected_sum[4];

endmodule