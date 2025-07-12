module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [16:0] remainder;  // 16 bits + carry
integer i;

always @(*) begin
    // Initialize
    remainder = {1'b0, A};
    result = 16'b0;

    // Division by zero check
    if (B == 8'b0) begin
        odd = 16'b0;
        result = 16'b0;
    end else begin
        // Division algorithm
        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder left by 1
            remainder = remainder << 1;
            
            // Compare upper 9 bits (8-bit divisor + carry)
            if (remainder[16:8] >= {1'b0, B}) begin
                remainder[16:8] = remainder[16:8] - {1'b0, B};
                result[15-i] = 1'b1;  // Set current quotient bit
            end
        end
        odd = remainder[15:0];  // Final remainder is 16-bit
    end
end

endmodule