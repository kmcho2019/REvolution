module multi_8bit(
    input   [7:0] A,
    input   [7:0] B,
    output  [15:0] product
);

    reg [15:0] product_reg;
    reg [7:0] A_shifted;

    integer i;

    always @(A or B) begin
        product_reg = 0;
        A_shifted = A;
        for (i = 0; i < 8; i++) begin
            if (B[i]) begin
                product_reg = product_reg + (A_shifted << i);
            end
            if (i < 7) begin
                A_shifted = A_shifted << 1;
            end
        end
        product = product_reg;
    end

endmodule