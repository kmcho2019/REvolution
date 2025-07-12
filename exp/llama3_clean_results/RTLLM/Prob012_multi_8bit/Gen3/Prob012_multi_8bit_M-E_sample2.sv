module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] partial_products [7:0];
    reg [15:0] sum;

    integer i;

    always @(*) begin
        // Initialize partial products
        for (i = 0; i < 8; i++) begin
            partial_products[i] = {8'b0, A} << i;
        end

        // Calculate partial products based on multiplier bits
        for (i = 0; i < 8; i++) begin
            if (~B[i]) begin
                partial_products[i] = 16'b0;
            end
        end

        // Calculate the sum of partial products
        sum = 16'b0;
        for (i = 0; i < 8; i++) begin
            sum = sum + partial_products[i];
        end

        product = sum;
    end

endmodule