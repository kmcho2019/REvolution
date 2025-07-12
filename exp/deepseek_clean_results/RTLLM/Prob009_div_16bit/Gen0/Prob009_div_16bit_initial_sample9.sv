module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [15:0] remainder;
integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    remainder = 16'b0;
    result = 16'b0;
    
    if (b_reg != 8'b0) begin  // Check for division by zero
        remainder[15:8] = 8'b0;
        remainder[7:0] = a_reg[15:8];  // Start with upper 8 bits of dividend
        
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = remainder << 1;  // Shift left
            remainder[0] = a_reg[i];    // Bring down next bit
            
            if (remainder[15:8] >= b_reg) begin
                remainder[15:8] = remainder[15:8] - b_reg;
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end
    end
    
    odd = remainder;  // Final remainder
end

endmodule