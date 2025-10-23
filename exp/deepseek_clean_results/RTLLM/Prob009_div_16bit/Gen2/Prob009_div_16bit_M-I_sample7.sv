module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [16:0] remainder;  // 16 bits + carry
reg [15:0] quotient;
reg [7:0] divisor;
integer i;

always @(*) begin
    // Initialize
    remainder = {1'b0, A[15:8]};  // Start with upper 8 bits
    quotient = 16'b0;
    divisor = B;

    // Division by zero check
    if (divisor == 8'b0) begin
        result = 16'b0;
        odd = 16'b0;
    end else begin
        // Process all 16 bits
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder and quotient
            remainder = {remainder[15:0], A[i]};
            quotient = quotient << 1;

            // Compare and subtract
            if (remainder[16:8] >= divisor) begin
                remainder[16:8] = remainder[16:8] - divisor;
                quotient[0] = 1'b1;
            end
        end

        // Assign outputs
        result = quotient;
        odd = remainder[15:0];
    end
end

endmodule