module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    reg [15:0] product_reg;
    integer i;

    always @(*) begin
        product_reg = 16'd0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                product_reg = product_reg + (16'd0 + (A << i));
        end
    end

    assign product = product_reg;

endmodule