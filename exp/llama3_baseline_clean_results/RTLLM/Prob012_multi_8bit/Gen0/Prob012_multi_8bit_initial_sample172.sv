module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] product_reg;
    reg [7:0] A_reg;
    integer i;

    always @(A or B) begin
        product_reg = 0;
        A_reg = A;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1) begin
                product_reg = product_reg + (A_reg << i);
            end
            A_reg = A_reg << 1;
        end
        product = product_reg;
    end

endmodule