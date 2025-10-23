module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);
    integer i;
    reg [15:0] product_reg;

    always @(*) begin
        product_reg = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                product_reg = product_reg + ( {8'b0, A} << i );
            end
        end
    end

    assign product = product_reg;

endmodule