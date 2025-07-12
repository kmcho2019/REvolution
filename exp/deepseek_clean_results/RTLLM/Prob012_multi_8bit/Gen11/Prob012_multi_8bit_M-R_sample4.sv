module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] product_reg;
    reg [7:0] multiplicand;
    integer i;

    always @(*) begin
        product_reg = 16'b0;
        multiplicand = A;
        
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                product_reg = product_reg + {8'b0, multiplicand};
            end
            multiplicand = multiplicand << 1;
        end
        
        product = product_reg;
    end

endmodule