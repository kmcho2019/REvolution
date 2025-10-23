module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Difference bits (not used for outputs, but for borrow computation)
    wire d0, d1, d2, d3;
    // Borrow signals between bits: borrow_in and borrow_out per bit
    wire b0, b1, b2, b3; 
    // b0 is borrow into LSB, which is 0 (no initial borrow)
    assign b0 = 1'b0;

    // Bit 0 subtractor: A[0] - B[0] - borrow_in (b0)
    assign d0 = A[0] ^ B[0] ^ b0;
    assign b1 = (~A[0] & B[0]) | ((~A[0] | B[0]) & b0);

    // Bit 1 subtractor
    assign d1 = A[1] ^ B[1] ^ b1;
    assign b2 = (~A[1] & B[1]) | ((~A[1] | B[1]) & b1);

    // Bit 2 subtractor
    assign d2 = A[2] ^ B[2] ^ b2;
    assign b3 = (~A[2] & B[2]) | ((~A[2] | B[2]) & b2);

    // Bit 3 subtractor
    assign d3 = A[3] ^ B[3] ^ b3;
    // borrow_out after MSB subtraction indicates A < B
    wire borrow_out = (~A[3] & B[3]) | ((~A[3] | B[3]) & b3);

    // Equality signals for each bit using XNOR
    wire eq0 = (A[0] ~^ B[0]);
    wire eq1 = (A[1] ~^ B[1]);
    wire eq2 = (A[2] ~^ B[2]);
    wire eq3 = (A[3] ~^ B[3]);

    // Balanced AND tree for all bits equal
    wire eq_01 = eq0 & eq1;
    wire eq_23 = eq2 & eq3;
    wire equal_bits = eq_01 & eq_23;

    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule