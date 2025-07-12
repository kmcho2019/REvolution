module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd  // 16-bit remainder
);

reg [15:0] a_reg;  // register to hold the dividend value
reg [7:0] b_reg;   // register to hold the divisor value
reg [15:0] result_reg;  // register to hold the quotient value
reg [15:0] odd_reg;  // register to hold the remainder value

always @(*) begin
    a_reg = A;  // update the dividend register
    b_reg = B;  // update the divisor register
end

always @(*) begin
    result_reg = 0;  // initialize the quotient register
    odd_reg = a_reg;  // initialize the remainder register
    
    for (int i = 15; i >= 8; i--) begin
        if (odd_reg[15:8] >= b_reg) begin
            result_reg[i-7] = 1;  // set the quotient bit
            odd_reg = {odd_reg[7:0], 1'b0} - {b_reg, 8'd0};  // update the remainder
        end else begin
            odd_reg = {odd_reg[7:0], 1'b0};  // shift the remainder
        end
    end
    
    result = result_reg;  // assign the quotient value
    odd = odd_reg;  // assign the remainder value
end

endmodule