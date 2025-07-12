module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] temp_quotient;
    reg [15:0] temp_remainder;
    reg [7:0] divisor;
    reg [7:0] dividend;
    reg [15:0] quotient;
    reg [15:0] remainder;
    
    quotient = 0;
    remainder = a_reg;
    divisor = b_reg;
    
    for (int i = 15; i >= 8; i--) begin
        dividend = remainder[15:8];
        
        if (dividend > divisor) begin
            quotient = quotient + (1 << (i - 8));
            remainder = (dividend - divisor) << (i - 8);
        end else begin
            remainder = dividend << (i - 8);
        end
        
        remainder = remainder + (remainder[0] ? 1 : 0);
    end
    
    result = quotient;
    odd = remainder;
end

endmodule