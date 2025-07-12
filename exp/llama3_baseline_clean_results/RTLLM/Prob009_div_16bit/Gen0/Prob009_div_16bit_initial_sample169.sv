module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

// First always block to update a_reg and b_reg
always @(*)
begin
    a_reg = A;
    b_reg = B;
end

// Second always block to perform the division operation
always @(*)
begin
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [7:0] temp;
    reg [15:0] dividend;
    
    quotient = 0;
    remainder = 0;
    dividend = a_reg;
    
    // Perform the division operation
    for (int i = 15; i >= 0; i--)
    begin
        temp = {remainder[7:0], dividend[15]};
        if (temp >= b_reg)
        begin
            remainder = (temp - b_reg);
            quotient = {quotient[14:0], 1'b1};
        end
        else
        begin
            remainder = temp;
            quotient = {quotient[14:0], 1'b0};
        end
        
        dividend = dividend << 1;
    end
    
    // Update the result and odd
    result = quotient;
    odd = remainder;
end

endmodule