module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [7:0] remainder;  // Reduced to 8 bits
    integer i;

    always @(*) begin
        remainder = 8'b0;
        result = 16'b0;

        // Division by zero check with optimized implementation
        if (B == 8'b0) begin
            odd = 16'b0;
        end else begin
            // Process upper 8 bits
            for (i = 15; i >= 8; i = i - 1) begin
                remainder = {remainder[6:0], A[i]};
                if (remainder >= B) begin
                    remainder = remainder - B;
                    result[i] = 1'b1;
                end
            end

            // Process lower 8 bits
            for (i = 7; i >= 0; i = i - 1) begin
                remainder = {remainder[6:0], A[i]};
                if (remainder >= B) begin
                    remainder = remainder - B;
                    result[i] = 1'b1;
                end
            end

            // Direct assignment for remainder (zero-extended)
            odd = {8'b0, remainder};
        end
    end

endmodule