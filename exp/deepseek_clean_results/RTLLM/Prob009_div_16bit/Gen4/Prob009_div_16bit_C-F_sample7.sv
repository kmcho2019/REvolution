module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] remainder;
reg [15:0] dividend;
reg [15:0] divisor_ext;  // Zero-extended divisor
integer i;

always @(*) begin
    // Initialize
    dividend = A;
    divisor_ext = {8'b0, B};  // Zero-extend divisor once
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
            
            // Compare remainder with zero-extended divisor
            if (remainder >= divisor_ext) begin
                result[i] = 1'b1;
                remainder = remainder - divisor_ext;
            end
            else begin
                result[i] = 1'b0;
            end
        end
        odd = remainder;  // Final remainder is the odd output
    end
end

endmodule