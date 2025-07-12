module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [4:0] borrow;  // borrow[0] = 0 (initial borrow in)
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : bit_subtract
            // difference bit = A[i] XOR B[i] XOR borrow_in
            assign diff[i] = A[i] ^ B[i] ^ borrow[i];
            // borrow_out = (~A[i] & B[i]) | ((~A[i] | B[i]) & borrow_in)
            assign borrow[i+1] = (~A[i] & B[i]) | ((~A[i] | B[i]) & borrow[i]);
        end
    endgenerate

    wire borrow_out = borrow[4];
    wire diff_zero = (diff == 4'b0000);

    assign A_less    = borrow_out;
    assign A_equal   = (~borrow_out) & diff_zero;
    assign A_greater = (~borrow_out) & (~diff_zero);

endmodule