module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] divisor;

always @(*) begin
    quotient = 0;
    remainder = 0;
    divisor = B;

    for (int i = 15; i >= 0; i--) begin
        // Shift the remainder to the left and add the current bit of the dividend
        remainder = {remainder[7:0], A[i]};
        
        // Compare the remainder with the divisor
        if (remainder[15:8] >= divisor) begin
            // Set the corresponding bit in the quotient
            quotient = quotient | (1 << i);
            
            // Update the remainder
            remainder = {remainder[7:0], 8'd0} - divisor;
        end
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule