module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Direct multiplication approach
    assign product = A * B;

    // Alternatively, the shift-and-add method can be explored but is not necessary here
    // wire [15:0] temp_product;
    // assign product = temp_product;
    // generate
    //     for (genvar i = 0; i < 8; i++) begin
    //         if (B[i] == 1'b1) begin
    //             assign temp_product = temp_product + (A << i);
    //         end
    //     end
    // endgenerate

endmodule