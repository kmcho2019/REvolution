module multi_8bit(
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] product
);
    integer i;
    reg [15:0] product_reg;
    reg [15:0] shifted_A;

    always @(*) begin
        product_reg = 16'b0;
        shifted_A = {8'b0, A}; // place A in lower 8 bits of 16-bit reg
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i]) begin
                product_reg = product_reg + shifted_A;
            end
            shifted_A = shifted_A << 1;
        end
    end

    assign product = product_reg;
endmodule