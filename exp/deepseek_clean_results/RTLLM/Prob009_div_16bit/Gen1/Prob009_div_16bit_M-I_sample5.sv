module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    always @(*) begin
        reg [15:0] quotient = 0;
        reg [16:0] remainder = 0; // 17-bit for comparison
        reg [15:0] dividend = A;
        reg [7:0] divisor = B;
        
        if (divisor == 0) begin
            result = 16'hFFFF; // Indicate division by zero
            odd = 16'hFFFF;
        end else begin
            for (integer i = 15; i >= 0; i = i - 1) begin
                // Shift remainder and quotient left
                remainder = remainder << 1;
                quotient = quotient << 1;
                
                // Bring down next bit from dividend
                remainder[0] = dividend[i];
                
                // Compare and subtract if possible
                if (remainder[16:9] >= divisor) begin
                    remainder[16:9] = remainder[16:9] - divisor;
                    quotient[0] = 1'b1;
                end
            end
            
            result = quotient;
            odd = remainder[15:0]; // Final remainder is 16-bit
        end
    end

endmodule