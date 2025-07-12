module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] remainder;
reg [15:0] dividend;
reg [7:0] divisor;
integer i;

always @(*) begin
    // Initialize
    dividend = A;
    divisor = B;
    result = 16'b0;
    remainder = 16'b0;
    
    // Check for division by zero
    if (B == 8'b0) begin
        result = 16'hFFFF;  // Max value as error indicator
        odd = 16'hFFFF;
    end
    else begin
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next dividend bit
            remainder = {remainder[14:0], dividend[i]};
            
            // Compare remainder with divisor
            if (remainder >= {8'b0, divisor}) begin
                result[i] = 1'b1;
                remainder = remainder - {8'b0, divisor};
            end
            else begin
                result[i] = 1'b0;
            end
        end
        odd = remainder;  // Final remainder is the odd output
    end
end

endmodule