module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] product_reg;
    reg [7:0] A_reg;
    reg [7:0] B_reg;
    reg [2:0] counter;

    initial begin
        product_reg = 16'd0;
        counter = 3'd0;
    end

    always @(*) begin
        A_reg = A;
        B_reg = B;
    end

    always @(posedge counter[0]) begin
        if (counter < 3'd8) begin
            if (B_reg[7 - counter] == 1'b1) begin
                product_reg = product_reg + (A_reg << counter);
            end
            counter = counter + 1;
        end
    end

    assign product = product_reg;

endmodule