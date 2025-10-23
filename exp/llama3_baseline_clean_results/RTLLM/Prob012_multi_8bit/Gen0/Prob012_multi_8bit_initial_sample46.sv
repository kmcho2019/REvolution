module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] product_reg;
    assign product = product_reg;

    always @(A or B) begin
        product_reg = 0;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                product_reg = product_reg + (A << i);
            end
        end
    end

endmodule