module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] prod_reg;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    integer i;

    always @(*) begin
        prod_reg = 16'b0;
        multiplicand = A;
        multiplier = B;
        
        for (i = 0; i < 8; i = i + 1) begin
            if (multiplier[0]) begin
                prod_reg = prod_reg + multiplicand;
            end
            multiplicand = multiplicand << 1;
            multiplier = multiplier >> 1;
        end
    end

    assign product = prod_reg;

endmodule