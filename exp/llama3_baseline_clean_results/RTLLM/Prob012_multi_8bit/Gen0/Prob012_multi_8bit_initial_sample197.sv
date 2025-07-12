module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] product_reg;
reg [7:0] A_reg;
reg [7:0] B_reg;
reg [3:0] counter;

always @(A or B) begin
    product_reg = 0;
    A_reg = A;
    B_reg = B;
    counter = 0;
end

always @(*) begin
    if (counter < 8) begin
        if (B_reg[7 - counter]) begin
            product_reg = product_reg + (A_reg << counter);
        end
        counter = counter + 1;
        B_reg = {1'b0, B_reg[7:1]};
    end
end

assign product = product_reg;

endmodule