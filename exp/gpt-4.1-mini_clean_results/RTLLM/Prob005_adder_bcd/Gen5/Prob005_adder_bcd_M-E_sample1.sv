module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum_AB;        // Sum of A and B
    wire       corr_AB;       // Correction needed after A+B
    wire [4:0] corr_sum_AB;  // Corrected sum after A+B

    wire [4:0] sum_Cin;       // Sum of corrected sum and Cin
    wire       corr_Cin;      // Correction needed after adding Cin
    wire [4:0] corr_sum_Cin;  // Corrected sum after adding Cin

    // Step 1: Add A and B
    assign sum_AB = A + B;

    // Detect if correction needed after adding A and B
    // Correction needed if sum_AB > 9 or if lower 4 bits > 9 or MSB set 
    // Here, sum_AB is 5 bits to include possible carry
    assign corr_AB = (sum_AB > 5'd9);

    // Apply correction of 6 if needed
    assign corr_sum_AB = corr_AB ? (sum_AB + 5'd6) : sum_AB;

    // Step 2: Add Cin to corrected sum
    assign sum_Cin = corr_sum_AB + Cin;

    // Detect correction after adding Cin
    assign corr_Cin = (sum_Cin > 5'd9);

    // Apply correction if needed
    assign corr_sum_Cin = corr_Cin ? (sum_Cin + 5'd6) : sum_Cin;

    // Output sum and carry-out
    assign Sum  = corr_sum_Cin[3:0];
    assign Cout = corr_Cin;

endmodule