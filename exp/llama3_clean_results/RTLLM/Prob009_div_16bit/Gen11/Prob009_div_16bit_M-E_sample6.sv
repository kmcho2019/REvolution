module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = A;
    
    if (B == 0) begin
        // Handle division by zero
        result = 16'hFFFF;
        odd = 16'hFFFF;
    end else begin
        for (int i = 15; i >= 7; i--) begin
            reg [15:0] temp;
            temp = {remainder[15:8], 8'd0} - B;
            
            if (temp[15]) begin
                // Result is negative, restore and set quotient bit to 0
                remainder = {remainder[15:8], 8'd0};
            end else begin
                // Result is non-negative, set quotient bit to 1
                quotient[15 - i] = 1'b1;
                remainder = temp;
            end
            
            // Shift in the next bit of the dividend
            remainder[15:1] = remainder[14:0];
            remainder[0] = (i > 7)? A[15 - i] : 1'b0;
        end
        
        // Assign the final quotient and remainder
        result = {8'd0, quotient[7:0]};
        odd = remainder;
    end
end

endmodule