module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;
reg [15:0] quotient_reg;
reg [15:0] remainder_reg;

// Always block to register input values
always @(*)
begin
    a_reg = A;
    b_reg = B;
end

// Always block to perform division operation
always @(*)
begin
    quotient_reg = 0;
    remainder_reg = a_reg;
    
    for (int i = 15; i >= 8; i--)
    begin
        // Extract the higher bits of the dividend
        reg [7:0] temp;
        temp = remainder_reg [15:8];
        
        // Compare these bits with the divisor
        if (temp >= b_reg)
        begin
            // Set the quotient to 1 and update the remainder
            quotient_reg = quotient_reg + (1 << (i - 8));
            remainder_reg = {remainder_reg [7:0], 1'b0};
            remainder_reg = remainder_reg - (b_reg << (i - 8));
        end
        else
        begin
            // Set the quotient to 0 and update the remainder
            remainder_reg = {remainder_reg [7:0], 1'b0};
        end
    end
    
    // Update the output ports
    result = quotient_reg;
    odd = remainder_reg;
end

endmodule