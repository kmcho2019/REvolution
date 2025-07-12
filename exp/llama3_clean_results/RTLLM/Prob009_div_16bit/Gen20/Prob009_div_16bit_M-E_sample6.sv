module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] quotient;
reg [7:0] remainder;
reg [3:0] counter;

always @(*) begin
    quotient = 0;
    remainder = 0;
    dividend = A;
    divisor = B;
    counter = 8;
    
    while (counter > 0) begin
        if (dividend[15:8] >= divisor) begin
            quotient = quotient | (1 << (counter - 1));
            dividend[15:8] = dividend[15:8] - divisor;
        end
        
        // Shift dividend to the left by 1 bit
        dividend = {dividend[14:0], 1'b0};
        
        counter = counter - 1;
    end
    
    result = quotient;
    odd = {8'd0, dividend[7:0]};
end

endmodule