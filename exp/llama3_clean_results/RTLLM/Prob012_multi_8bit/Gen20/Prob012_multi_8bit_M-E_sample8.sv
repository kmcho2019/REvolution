module multi_8bit_hybrid(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Booth encoding of the multiplier
    reg [7:0] booth_encoded_B;
    always @(*) begin
        booth_encoded_B = 0;
        for (int i = 0; i < 7; i++) begin
            if (B[i] == 1'b1 && B[i+1] == 1'b0) begin
                booth_encoded_B[i] = 1'b1;
            end else if (B[i] == 1'b0 && B[i+1] == 1'b1) begin
                booth_encoded_B[i] = 1'b1;
            end
        end
    end

    // Generate partial products based on Booth-encoded multiplier
    reg [15:0] partial_products [7:0];
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            if (booth_encoded_B[i] == 1'b1) begin
                partial_products[i] = (A << i);
            end else begin
                partial_products[i] = 0;
            end
        end
    end

    // Accumulate partial products to obtain final product
    reg [15:0] temp_product;
    always @(*) begin
        temp_product = 0;
        for (int i = 0; i < 8; i++) begin
            temp_product = temp_product + partial_products[i];
        end
    end

    assign product = temp_product;

endmodule