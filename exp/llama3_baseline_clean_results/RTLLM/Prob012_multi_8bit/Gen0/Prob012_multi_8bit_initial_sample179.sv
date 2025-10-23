module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    reg [15:0] prod_reg;
    reg [7:0] a_shifted;
    integer i;

    always @(A or B) begin
        prod_reg = 0;
        a_shifted = A;
        for (i = 0; i < 8; i++) begin
            if (B[i]) begin
                prod_reg = prod_reg + (a_shifted);
            end
            a_shifted = a_shifted << 1;
        end
        product = prod_reg;
    end

endmodule