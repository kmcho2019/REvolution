module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] product_reg;
    reg [7:0] multiplicand_reg;
    reg [2:0] counter;

    initial begin
        product_reg = 0;
        multiplicand_reg = A;
        counter = 0;
    end

    always @(posedge clk) begin
        if (counter < 8) begin
            if (B[counter] == 1'b1) begin
                product_reg = product_reg + multiplicand_reg;
            end
            multiplicand_reg = multiplicand_reg << 1;
            counter = counter + 1;
        end
    end

    assign product = product_reg;

endmodule