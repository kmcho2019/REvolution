module multi_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    integer i;
    reg [15:0] shifted_A;
    reg [15:0] product_reg;

    always @(*) begin
        shifted_A = {8'b0, A};  // Extend A to 16 bits before shifting
        product_reg = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i])
                product_reg = product_reg + shifted_A;
            shifted_A = shifted_A << 1;
        end
    end

    assign product = product_reg;

endmodule