module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    integer i;
    reg [15:0] prod_reg;

    always @(*) begin
        prod_reg = 16'd0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                prod_reg = prod_reg + (A << i);
        end
    end

    assign product = prod_reg;

endmodule