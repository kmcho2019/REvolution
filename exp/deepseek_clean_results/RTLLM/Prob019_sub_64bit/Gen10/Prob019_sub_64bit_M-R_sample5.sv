module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Ripple-borrow subtractor implementation
    wire [64:0] borrow;  // borrow[0] is input borrow (0 for subtraction)
    assign borrow[0] = 1'b0;  // No input borrow for simple subtraction

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : sub_loop
            // Full subtractor implementation
            assign result[i] = A[i] ^ B[i] ^ borrow[i];
            assign borrow[i+1] = (~A[i] & B[i]) | (~A[i] & borrow[i]) | (B[i] & borrow[i]);
        end
    endgenerate

    // Overflow detection (same logic as original)
    wire operands_diff_sign = A[63] != B[63];
    wire result_diff_sign = A[63] != result[63];
    assign overflow = operands_diff_sign && result_diff_sign;

endmodule