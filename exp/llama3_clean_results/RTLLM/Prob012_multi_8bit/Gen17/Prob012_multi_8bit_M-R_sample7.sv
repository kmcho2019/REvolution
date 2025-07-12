// Module: multi_8bit_refactored
// Description: 8-bit multiplier using shift-and-add method
module multi_8bit_refactored(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;
    reg [7:0] a_reg;
    reg [7:0] b_reg;

    always @(A or B) begin
        prod = 0;
        a_reg = A;
        b_reg = B;
        for (int i = 0; i < 8; i++) begin
            if (b_reg[0]) begin
                prod = prod + {8'd0, a_reg};
            end
            a_reg = a_reg << 1;
            b_reg = b_reg >> 1;
        end
        product = prod;
    end

endmodule