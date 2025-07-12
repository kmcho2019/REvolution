module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // internal register to store the product
    reg [7:0] temp_A;  // temporary register to store A
    reg [7:0] temp_B;  // temporary register to store B
    integer i;  // loop counter

    always @(A or B) begin
        prod = 0;  // initialize product to 0
        temp_A = A;  // initialize temp_A to A
        temp_B = B;  // initialize temp_B to B

        for (i = 0; i < 8; i = i + 1) begin
            if (temp_B[0] == 1'b1) begin
                prod = prod + temp_A;  // add temp_A to product if temp_B[0] is 1
            end
            temp_A = temp_A << 1;  // shift temp_A left by 1 bit
            temp_B = temp_B >> 1;  // shift temp_B right by 1 bit
        end

        product = prod;  // assign final product to output
    end

endmodule