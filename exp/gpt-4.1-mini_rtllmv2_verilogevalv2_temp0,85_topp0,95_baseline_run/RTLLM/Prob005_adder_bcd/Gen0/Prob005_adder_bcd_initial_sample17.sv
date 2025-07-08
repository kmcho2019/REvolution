module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;      // 5 bits to hold carry out of 4-bit addition
    wire [4:0] corrected_sum;

    // Binary addition of inputs and carry in
    assign binary_sum = A + B + Cin;

    // Check if correction is needed: sum > 9 or carry out from binary addition
    wire correction_needed = (binary_sum > 9);

    // Add correction value 6 if needed
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Output sum and carry out
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule