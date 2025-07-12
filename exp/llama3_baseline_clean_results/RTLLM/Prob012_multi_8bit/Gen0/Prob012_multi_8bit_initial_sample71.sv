module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] product_reg;
reg [7:0] A_reg;
reg [7:0] B_reg;
reg [3:0] counter;

always @(*) begin
    product_reg = 0;
    A_reg = A;
    B_reg = B;
    counter = 0;
    for(counter = 0; counter < 8; counter = counter + 1) begin
        if(B_reg[7 - counter]) begin
            product_reg = product_reg + (A_reg << counter);
        end
        if(counter < 7) begin
            A_reg = A_reg << 1;
        end
    end
    product = product_reg;
end

endmodule