module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;
    reg [7:0] temp_A;
    reg [7:0] temp_B;
    integer i;

    always @(*) begin
        prod = 16'b0;
        temp_A = A;
        temp_B = B;
        for (i = 0; i < 8; i = i + 1) begin
            if (temp_B[0] == 1'b1) begin
                prod = prod + {8'b0, temp_A};
            end
            temp_A = temp_A << 1;
            temp_B = temp_B >> 1;
        end
        product = prod;
    end

endmodule