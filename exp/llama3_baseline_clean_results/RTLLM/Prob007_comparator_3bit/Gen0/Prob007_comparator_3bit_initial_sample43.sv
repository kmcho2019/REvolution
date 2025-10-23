module comparator_3bit(
    input  wire [2:0] A,  // First 3-bit input operand
    input  wire [2:0] B,  // Second 3-bit input operand
    output wire         A_greater,  // 1-bit output indicating if A is greater than B
    output wire         A_equal,    // 1-bit output indicating if A is equal to B
    output wire         A_less      // 1-bit output indicating if A is less than B
);

    // Compare A and B
    assign A_greater = (A > B) ? 1'b1 : 1'b0;
    assign A_equal   = (A == B) ? 1'b1 : 1'b0;
    assign A_less    = (A < B) ? 1'b1 : 1'b0;

endmodule