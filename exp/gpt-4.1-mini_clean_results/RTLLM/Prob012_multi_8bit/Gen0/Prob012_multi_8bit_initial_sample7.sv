module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    reg [15:0] product_reg;
    reg [15:0] multiplicand_shifted;
    integer i;

    always @(*) begin
        product_reg = 16'd0;
        multiplicand_shifted = {8'd0, A};  // extend A to 16 bits for shifting and adding
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                product_reg = product_reg + multiplicand_shifted;
            multiplicand_shifted = multiplicand_shifted << 1;
        end
    end

    assign product = product_reg;

endmodule