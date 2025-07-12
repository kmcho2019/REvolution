module multi_8bit(
    input   [7:0] A,
    input   [7:0] B,
    output  [15:0] product
);

    always @(*) begin
        product = 16'd0; // Initialize product to zero
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                // Add A shifted left by i bits to the product
                product = product + (A << i);
            end
        end
    end

endmodule