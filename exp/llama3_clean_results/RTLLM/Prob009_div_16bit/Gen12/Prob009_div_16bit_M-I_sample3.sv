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
    remainder = A;
    divisor = B;
    
    if (B == 0) begin
        // Handle division by zero
        result = 16'hFFFF;
        odd = 16'hFFFF;
    end else if (B > A) begin
        // Handle divisor larger than dividend
        result = 0;
        odd = A;
    end else begin
        for (int i = 15; i >= 7; i--) begin
            reg [15:0] temp;
            temp = {remainder[15:8], 8'd0} - {8'd0, divisor};
            
            if (temp[15]) begin
                // Result is negative, restore and set quotient bit to 0
                remainder = {remainder[15:8], 8'd0};
            end else begin
                // Result is non-negative, set quotient bit to 1
                quotient[15 - i] = 1'b1;
                remainder = temp;
            end
            
            // Shift in the next bit of the dividend
            if (i < 8) begin
                remainder[15:1] = remainder[14:0];
                remainder[0] = A[15 - i];
            end
        end
        
        // Assign the final quotient and remainder
        result = quotient;
        odd = remainder;
    end
end

endmodule