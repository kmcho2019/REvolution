module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // 1-bit full subtractor module (internal)
    // Inputs: a, b, borrow_in
    // Outputs: diff, borrow_out
    // diff = a - b - borrow_in
    // borrow_out = (borrow needed when subtracting)
    function automatic [1:0] full_subtractor;
        input a, b, borrow_in;
        reg diff_bit;
        reg borrow_out_bit;
        begin
            diff_bit = a ^ b ^ borrow_in;
            // borrow occurs if (not a and b) or ((not a or b) and borrow_in)
            borrow_out_bit = (~a & b) | ((~a | b) & borrow_in);
            full_subtractor = {borrow_out_bit, diff_bit};
        end
    endfunction

    wire [3:0] diff;
    wire [3:0] borrow;

    // Bit 0 subtractor
    // borrow_in = 0
    wire [1:0] res0 = full_subtractor(A[0], B[0], 1'b0);
    assign borrow[0] = res0[1];
    assign diff[0]   = res0[0];

    // Bit 1 subtractor
    wire [1:0] res1 = full_subtractor(A[1], B[1], borrow[0]);
    assign borrow[1] = res1[1];
    assign diff[1]   = res1[0];

    // Bit 2 subtractor
    wire [1:0] res2 = full_subtractor(A[2], B[2], borrow[1]);
    assign borrow[2] = res2[1];
    assign diff[2]   = res2[0];

    // Bit 3 subtractor
    wire [1:0] res3 = full_subtractor(A[3], B[3], borrow[2]);
    assign borrow[3] = res3[1];
    assign diff[3]   = res3[0];

    wire borrow_out = borrow[3];
    wire diff_zero = (diff == 4'b0000);

    assign A_less    = borrow_out;
    assign A_equal   = ~borrow_out & diff_zero;
    assign A_greater = ~borrow_out & ~diff_zero;

endmodule