module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Perform bitwise subtraction A - B with borrow chain
    // Using full subtractor logic:
    // diff = A_bit ^ B_bit ^ borrow_in
    // borrow_out = (~A_bit & B_bit) | ((~A_bit | B_bit) & borrow_in)
    assign borrow0 = (~A[0] & B[0]);
    assign diff[0] = A[0] ^ B[0];

    assign borrow1 = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow0);
    assign diff[1] = A[1] ^ B[1] ^ borrow0;

    assign borrow2 = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow1);
    assign diff[2] = A[2] ^ B[2] ^ borrow1;

    assign borrow3 = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow2);
    assign diff[3] = A[3] ^ B[3] ^ borrow2;

    wire borrow_out = borrow3;

    wire diff_zero = (diff == 4'b0000);

    assign A_less    = borrow_out;
    assign A_equal   = ~borrow_out & diff_zero;
    assign A_greater = ~borrow_out & ~diff_zero;

endmodule