module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [8:0] remainder;  // 9 bits for comparison (8+1)
    integer i;

    always @(*) begin
        remainder = 9'b0;
        result = 16'b0;

        // Division by zero check
        if (B == 8'b0) begin
            odd = 16'b0;
        end else begin
            // Process each bit of the dividend
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left and bring down next dividend bit
                remainder = {remainder[7:0], A[i]};

                // Non-restoring division step
                if (remainder >= {1'b0, B}) begin
                    remainder = remainder - {1'b0, B};
                    result[i] = 1'b1;
                end
            end

            // Zero-extend remainder to 16 bits
            odd = {7'b0, remainder};
        end
    end

endmodule