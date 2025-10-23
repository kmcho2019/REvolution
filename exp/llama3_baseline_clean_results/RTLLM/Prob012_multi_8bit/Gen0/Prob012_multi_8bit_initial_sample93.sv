module multi_8bit(
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);

    reg [15:0] product_reg;

    always @(A or B) begin
        product_reg = 0;
        reg [7:0] A_reg = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                product_reg = product_reg + (A_reg << i);
            end
            // No need to shift A_reg as it's not used in the next iteration in the traditional sense,
            // but rather its shifted version is used directly in the multiplication.
        end
        product = product_reg;
    end

endmodule