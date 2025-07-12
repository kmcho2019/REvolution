module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] product_reg;
reg [7:0] A_reg;
reg [7:0] B_reg;
integer i;

always @(A or B) begin
    product_reg = 16'd0;
    A_reg = A;
    B_reg = B;
    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[0]) begin
            product_reg = product_reg + {{8{1'b0}}, A_reg};
        end
        A_reg = A_reg << 1;
        B_reg = B_reg >> 1;
    end
    product <= product_reg;
end

endmodule