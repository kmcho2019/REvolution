module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] product_reg;

    always @(A or B) begin
        product_reg = 0;
        reg [7:0] A_shifted = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                product_reg = product_reg + (A_shifted << i);
            end
            A_shifted = A_shifted << 1;
        end
        product = product_reg;
    end

endmodule