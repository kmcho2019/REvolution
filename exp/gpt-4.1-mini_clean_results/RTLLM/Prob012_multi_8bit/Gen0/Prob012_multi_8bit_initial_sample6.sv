module multi_8bit(
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product
);
    integer i;
    reg [15:0] partial_product;

    always @(*) begin
        partial_product = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                partial_product = partial_product + (A << i);
        end
        product = partial_product;
    end
endmodule