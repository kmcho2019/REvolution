module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;       // Difference bits (A - B)
    wire       borrow0, borrow1, borrow2, borrow3; // Borrows for each subtractor stage

    // 1-bit subtractor: Computes difference bit and borrow out
    // diff = A_bit - B_bit - borrow_in
    // borrow_out = (~A_bit & (B_bit | borrow_in)) | (B_bit & borrow_in)
    // This formula comes from binary subtraction logic
    function [1:0] subtract_bit;
        input A_bit, B_bit, borrow_in;
        reg diff_bit, borrow_out;
        begin
            diff_bit = A_bit ^ B_bit ^ borrow_in;
            borrow_out = (~A_bit & (B_bit | borrow_in)) | (B_bit & borrow_in);
            subtract_bit = {borrow_out, diff_bit};
        end
    endfunction

    // Stage 0 (LSB)
    wire borrow0_out;
    assign {borrow0_out, diff[0]} = subtract_bit(A[0], B[0], 1'b0);

    // Stage 1
    wire borrow1_out;
    assign {borrow1_out, diff[1]} = subtract_bit(A[1], B[1], borrow0_out);

    // Stage 2
    wire borrow2_out;
    assign {borrow2_out, diff[2]} = subtract_bit(A[2], B[2], borrow1_out);

    // Stage 3 (MSB)
    wire borrow3_out;
    assign {borrow3_out, diff[3]} = subtract_bit(A[3], B[3], borrow2_out);

    // borrow3_out is the final borrow out:
    // borrow3_out=1 means A < B
    // borrow3_out=0 means A >= B

    // Check if result is zero (A == B)
    wire is_zero;
    assign is_zero = ~(diff[0] | diff[1] | diff[2] | diff[3]);

    assign A_less    = borrow3_out;
    assign A_equal   = ~borrow3_out & is_zero;
    assign A_greater = ~borrow3_out & ~is_zero;

endmodule