module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    integer i;
    reg [15:0] product_reg;
    always @(*) begin
        product_reg = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                product_reg = product_reg + (A << i);
        end
    end
    assign product = product_reg;
endmodule