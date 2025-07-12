module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

always @(*) begin
    reg [15:0] temp_product = 0;
    reg [7:0] shifted_A = A;
    
    for (int i = 0; i < 8; i++) begin
        if (B[i])
            temp_product = temp_product + (shifted_A << i);
        shifted_A = shifted_A << 1;
    end
    
    product = temp_product;
end

endmodule