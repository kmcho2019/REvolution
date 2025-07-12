module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    wire [15:0] partial_product;
    assign product = partial_product;

    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            if (i == 0) begin
                assign partial_product = (B[i] == 1'b1)? A : 16'd0;
            end else begin
                wire [15:0] shift_A;
                assign shift_A = A << i;
                assign partial_product = (B[i] == 1'b1)? partial_product + shift_A : partial_product;
            end
        end
    endgenerate

endmodule