module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Ripple borrow signals: borrow_in at bit i is borrow[i], borrow_out at MSB is borrow[4]
    wire [4:0] borrow;
    assign borrow[0] = 1'b0; // no initial borrow

    // Calculate borrow for each bit: borrow[i+1] = (~A[i] & B[i]) | ( (B[i] ^ A[i]) & borrow[i] )
    assign borrow[1] = (~A[0] & B[0]) | ((B[0] ^ A[0]) & borrow[0]);
    assign borrow[2] = (~A[1] & B[1]) | ((B[1] ^ A[1]) & borrow[1]);
    assign borrow[3] = (~A[2] & B[2]) | ((B[2] ^ A[2]) & borrow[2]);
    assign borrow[4] = (~A[3] & B[3]) | ((B[3] ^ A[3]) & borrow[3]);

    // borrow_out at MSB indicates A < B
    assign A_less = borrow[4];

    // Equality check using direct comparator operator
    assign A_equal = (A == B);

    // A_greater is true if not less and not equal
    assign A_greater = ~A_less & ~A_equal;

endmodule