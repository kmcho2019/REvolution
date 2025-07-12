module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    result = 0;
    odd = A;
    
    if (B == 0) begin
        // Handle division by zero
        result = 16'hFFFF;
        odd = 16'hFFFF;
    end else begin
        for (int i = 15; i >= 8; i--) begin
            if (odd[15:8] >= B) begin
                result[15 - i] = 1'b1;
                odd[15:8] = odd[15:8] - B;
            end else begin
                result[15 - i] = 1'b0;
            end
            
            if (i > 8) begin
                odd = {odd[7:0], (i > 8) ? A[i - 8] : 1'b0};
            end
        end
        
        // Assign the final remainder
        odd = {8'd0, odd[7:0]};
    end
end

endmodule