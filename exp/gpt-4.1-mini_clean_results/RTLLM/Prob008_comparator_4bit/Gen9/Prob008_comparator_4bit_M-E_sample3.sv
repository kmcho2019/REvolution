module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate signals: borrow_in and borrow_out for each bit of subtraction
    wire [4:0] borrow; // borrow[0] = 0 (initial), borrow[4] = final borrow_out

    assign borrow[0] = 1'b0;

    // For each bit:
    // borrow_out[i+1] = (~A[i] & B[i]) | ((B[i] ^ ~A[i]) & borrow[i])
    // This is the standard borrow logic for A - B - borrow_in
    genvar i;
    wire [3:0] diff; // difference bits, not used for output but used to check zero result

    generate
        for (i = 0; i < 4; i = i + 1) begin : borrow_gen
            assign borrow[i+1] = (~A[i] & B[i]) | ((B[i] ^ ~A[i]) & borrow[i]);
            assign diff[i]     = A[i] ^ B[i] ^ borrow[i];
        end
    endgenerate

    // Equality check: all diff bits zero means A == B
    wire diff_zero = ~( |diff );

    // Outputs
    assign A_less    = borrow[4];
    assign A_equal   = diff_zero;
    assign A_greater = ~borrow[4] & ~diff_zero;

endmodule