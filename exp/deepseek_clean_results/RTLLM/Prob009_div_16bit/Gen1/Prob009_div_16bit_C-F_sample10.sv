module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [23:0] dividend;  // 16-bit + 8-bit for remainder
    reg [7:0] divisor;
    reg [8:0] diff;       // 9-bit for comparison (8+1)
    integer i;

    always @(*) begin
        dividend = {8'b0, A};  // 8-bit extension for remainder
        divisor = B;
        result = 16'b0;

        for (i = 0; i < 16; i = i + 1) begin
            // Shift left the dividend (and current quotient)
            dividend = dividend << 1;
            
            // Compare upper 8+1 bits with divisor
            if (dividend[23:16] >= divisor) begin
                dividend[23:16] = dividend[23:16] - divisor;
                result[15-i] = 1'b1;  // Set quotient bit
            end
            else begin
                result[15-i] = 1'b0;  // Clear quotient bit
            end
        end

        // Remainder is in upper 8 bits, zero-extended to 16
        odd = {8'b0, dividend[23:16]};
    end

endmodule