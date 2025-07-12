module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate wires for difference bits and borrow chain
    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // 1-bit subtractor (A - B - borrow_in)
    // diff = A ^ B ^ borrow_in
    // borrow_out = (~A & B) | ((~A | B) & borrow_in)
    function automatic [1:0] bit_subtract;
        input a, b, bin;
        reg d, bout;
        begin
            d = a ^ b ^ bin;
            bout = (~a & b) | ((~a | b) & bin);
            bit_subtract = {bout, d};
        end
    endfunction

    // Stage 0 (LSB)
    wire [1:0] stage0 = bit_subtract(A[0], B[0], 1'b0);
    assign diff[0] = stage0[0];
    assign borrow0 = stage0[1];

    // Stage 1
    wire [1:0] stage1 = bit_subtract(A[1], B[1], borrow0);
    assign diff[1] = stage1[0];
    assign borrow1 = stage1[1];

    // Stage 2
    wire [1:0] stage2 = bit_subtract(A[2], B[2], borrow1);
    assign diff[2] = stage2[0];
    assign borrow2 = stage2[1];

    // Stage 3 (MSB)
    wire [1:0] stage3 = bit_subtract(A[3], B[3], borrow2);
    assign diff[3] = stage3[0];
    assign borrow3 = stage3[1];

    // Equality check: diff all zeros
    wire eq = ~|diff;

    // A less than B if borrow out from MSB subtractor is set
    wire lt = borrow3;

    // A greater than B if no borrow and diff non-zero
    wire gt = ~borrow3 & ~eq;

    assign A_equal   = eq;
    assign A_less    = lt;
    assign A_greater = gt;

endmodule