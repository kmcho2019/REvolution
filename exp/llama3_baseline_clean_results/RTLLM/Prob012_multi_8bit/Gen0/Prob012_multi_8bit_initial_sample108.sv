module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

reg [15:0] temp_product;
reg [7:0] shifted_A;
reg [2:0] counter;

always @(posedge A or posedge B) begin
    temp_product = 0;
    shifted_A = A;
    counter = 0;
    for (counter = 0; counter < 8; counter = counter + 1) begin
        if (B[counter])
            temp_product = temp_product + (shifted_A << counter);
        shifted_A = shifted_A << 1;
    end
    product = temp_product;
end

endmodule