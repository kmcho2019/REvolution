module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    // Zero division check
    wire zero_divisor = (B == 8'b0);
    
    // Main division logic
    always @(*) begin
        reg [15:0] quotient = 0;
        reg [8:0] remainder = 0;  // 9-bit for comparison
        
        // Handle zero divisor case
        if (zero_divisor) begin
            quotient = 16'hFFFF;
            remainder = 0;
        end
        else begin
            // Bit-serial division
            for (integer i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left and bring in next dividend bit
                remainder = {remainder[7:0], A[i]};
                
                // Compare and subtract if possible
                if (remainder >= {1'b0, B}) begin
                    remainder = remainder - {1'b0, B};
                    quotient[i] = 1'b1;
                end
                else begin
                    quotient[i] = 1'b0;
                end
                
                // Early termination if remaining bits are zero
                if (i > 0 && remainder == 0 && A[i-1:0] == 0) begin
                    quotient[i-1:0] = 0;  // Set remaining bits to zero
                    i = 0;  // Exit loop
                end
            end
        end
        
        // Assign outputs
        result = quotient;
        odd = remainder[7:0];
    end

endmodule