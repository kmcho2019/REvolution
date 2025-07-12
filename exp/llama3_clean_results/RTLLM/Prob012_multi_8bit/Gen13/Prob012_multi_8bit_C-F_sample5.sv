module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Direct multiplication approach
    assign product = A * B;

    // Alternatively, the shift-and-add method can be explored
    // reg [15:0] temp_product;
    // always @(*) begin
    //     temp_product = 0;
    //     for (int i = 0; i < 8; i++) begin
    //         if (B[i] == 1'b1) begin
    //             temp_product = temp_product + (A << i);
    //         end
    //     end
    //     product = temp_product;
    // end

    // More efficient multiplier architecture (e.g., array multiplier)
    // reg [15:0] array_product;
    // always @(*) begin
    //     array_product = 0;
    //     for (int i = 0; i < 8; i++) begin
    //         if (B[i] == 1'b1) begin
    //             array_product = array_product + (A << i);
    //         end
    //     end
    //     product = array_product;
    // end

endmodule