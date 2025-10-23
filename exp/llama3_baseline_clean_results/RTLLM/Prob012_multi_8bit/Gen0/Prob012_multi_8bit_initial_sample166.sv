module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] prod_reg;
reg [7:0] A_shift;

always @(A or B) begin
    prod_reg = 16'd0;
    A_shift = A;
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin
            prod_reg = prod_reg + (A_shift << i);
        end
        if (i < 7) begin
            A_shift = A_shift << 1;
        end
    end
    product = prod_reg;
end

endmodule