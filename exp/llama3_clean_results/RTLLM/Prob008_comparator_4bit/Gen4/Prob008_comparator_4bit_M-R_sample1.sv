module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    assign A_equal = (A == B) ? 1'b1 : 1'b0;

    assign A_greater = (A > B) ? 1'b1 : 1'b0;
    assign A_less    = (A < B) ? 1'b1 : 1'b0;

    // Alternatively, to avoid using comparison operators directly
    // and to manually control the comparison logic:
    // assign A_greater = (A[3:0] > B[3:0]) ? 1'b1 : 1'b0;
    // However, the above line still uses the greater than operator.
    // For a fully manual approach without using > or < operators:
    // Compare bits from MSB to LSB
    // wire [3:0] diff;
    // assign diff = A - B;
    // assign A_greater = (diff[3] == 1'b0 && diff != 4'b0000) ? 1'b1 : 1'b0; // Indicates A > B if no borrow and result is not zero
    // assign A_less    = (diff[3] == 1'b1) ? 1'b1 : 1'b0; // Indicates A < B if borrow occurred

    // But, the most efficient and straightforward way given the original constraints and focusing on PPA metrics
    // would indeed utilize the comparison operators as initially shown, due to their simplicity and the compiler's
    // ability to optimize these operations for the target technology.

endmodule