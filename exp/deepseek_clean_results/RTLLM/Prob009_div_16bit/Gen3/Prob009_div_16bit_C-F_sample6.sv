module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [8:0] remainder;  // 9 bits for comparison (8+1)
    reg [15:0] dividend;
    integer i;

    always @(*) begin
        dividend = A;
        remainder = 9'b0;
        result = 16'b0;

        // Division by zero check
        if (B == 8'b0) begin
            odd = 16'b0;
        end else begin
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left and bring down next dividend bit
                remainder = {remainder[7:0], dividend[i]};

                // Non-restoring division step
                if (remainder >= B) begin
                    remainder = remainder - B;
                    result[i] = 1'b1;
                end
                // else: result[i] remains 0 (implicit from initialization)
            end

            // Zero-extend remainder to 16 bits
            odd = {7'b0, remainder};
        end
    end

endmodule