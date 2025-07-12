module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;
    integer i;

    always @(A or B) begin
        prod = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin
                prod = prod + (A << i);
            end
        end
        product = prod;
    end

endmodule