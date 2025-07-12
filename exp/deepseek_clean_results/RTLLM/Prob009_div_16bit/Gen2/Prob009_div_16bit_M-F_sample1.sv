module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [16:0] remainder;  // Extra bit for carry during subtraction
integer i;

always @(*) begin
    result = 16'b0;
    remainder = {1'b0, A};  // Initialize with dividend
    
    if (B != 8'b0) begin  // Check for division by zero
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = remainder << 1;  // Shift left
            
            if (remainder[16:8] >= {1'b0, B}) begin  // Compare upper 9 bits
                remainder[16:8] = remainder[16:8] - {1'b0, B};
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end
    end else begin
        result = 16'b0;
        remainder = 17'b0;
    end
    
    odd = remainder[15:0];  // Final remainder (16 bits)
end

endmodule