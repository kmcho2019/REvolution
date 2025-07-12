module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    always @(*) begin
        reg [8:0] remainder; // 9-bit to handle carry during subtraction
        reg [15:0] dividend;
        reg [7:0] divisor;
        integer i;

        // Initialize
        dividend = A;
        divisor = B;
        result = 16'b0;
        remainder = 9'b0;

        // Handle zero divisor case
        if (divisor == 8'b0) begin
            odd = 8'b0;
            result = 16'b0;
        end else begin
            // Perform division
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder and dividend
                remainder = {remainder[7:0], dividend[i]};
                
                // Compare and subtract
                if (remainder >= {1'b0, divisor}) begin
                    remainder = remainder - {1'b0, divisor};
                    result[i] = 1'b1;
                end else begin
                    result[i] = 1'b0;
                end
            end
            
            // Final remainder
            odd = remainder[7:0];
        end
    end

endmodule