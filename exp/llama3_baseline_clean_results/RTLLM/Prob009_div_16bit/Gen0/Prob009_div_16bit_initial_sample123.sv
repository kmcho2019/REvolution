module div_16bit(
    input  [15:0] A,  // 16-bit dividend
    input  [7:0]  B,  // 8-bit divisor
    output [15:0] result,  // 16-bit quotient
    output [15:0] odd    // 16-bit remainder
);

reg [15:0] a_reg;
reg [7:0]  b_reg;
reg [15:0] quotient;
reg [15:0] remainder;

// First always block to update a_reg and b_reg
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block to perform division
always @(*) begin
    quotient = 0;
    remainder = a_reg;
    for (int i = 15; i >= 8; i--) begin
        // Extract higher bits of dividend matching bit width of divisor
        reg [7:0] temp_dividend;
        temp_dividend = remainder[15:8];
        
        // Compare higher bits of dividend with divisor and update quotient
        if (temp_dividend >= b_reg) begin
            quotient[15-i+8] = 1;
            remainder = {remainder[7:0], 1'b0} - {b_reg, 8'b0};
        end else begin
            remainder = {remainder[7:0], 1'b0};
        end
    end
    
    // Update result and odd
    result = quotient;
    odd    = remainder;
end

endmodule