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
    end else begin
        // Division algorithm
        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder and quotient left
            remainder = remainder << 1;
            result = result << 1;

            // Compare upper bits with divisor
            if (remainder[16:9] >= B) begin
                remainder[16:9] = remainder[16:9] - B;
                result[0] = 1'b1;
            end
        end
        odd = remainder[16:1];  // Final remainder
    end
end

endmodule