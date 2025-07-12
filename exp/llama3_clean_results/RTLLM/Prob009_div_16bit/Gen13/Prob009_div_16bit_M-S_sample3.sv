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
    end else if (B > A) begin
        // Handle divisor larger than dividend
        result = 0;
        odd = A;
    end else begin
        for (int i = 15; i >= 0; i--) begin
            if (remainder >= B) begin
                quotient[15 - i] = 1'b1;
                remainder = remainder - B;
            end
            if (i > 7) begin
                remainder = remainder << 1;
            end
        end
        
        // Assign the final quotient and remainder
        result = quotient;
        odd = remainder;
    end
end

endmodule