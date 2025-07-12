module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] remainder;
integer i;

always @(*) begin
    result = 16'b0;
    remainder = {8'b0, A[15:8]};  // Initialize with upper 8 bits of dividend
    
    if (B != 8'b0) begin  // Check for division by zero
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = remainder << 1;          // Shift left
            remainder[0] = A[i];                // Bring down next bit
            
            if (remainder[15:8] >= B) begin    // Compare upper 8 bits
                remainder[15:8] = remainder[15:8] - B;
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end
    end
    
    odd = remainder;  // Final remainder
end

endmodule