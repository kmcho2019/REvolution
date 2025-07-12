module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [3:0] shift_amount;

always @(*) begin
    quotient = 0;
    remainder = A;
    
    for (reg [3:0] i = 8; i >= 0; i = i - 1) begin
        reg [15:0] temp_divisor;
        temp_divisor = B << i;
        
        if (temp_divisor <= remainder) begin
            quotient = quotient | (1 << i);
            remainder = remainder - temp_divisor;
        end
    end
    
    result = quotient;
    odd = remainder;
end

endmodule