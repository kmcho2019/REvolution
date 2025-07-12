module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    always @(*) begin
        reg [8:0] remainder = 0;  // 9-bit to handle overflow
        integer i;
        
        // Handle zero divisor case
        if (B == 8'b0) begin
            result = 16'b0;
            odd = 8'b0;
        end
        else begin
            remainder = 0;
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left and add next bit
                remainder = {remainder[7:0], A[i]};
                
                // Compare and subtract if possible
                if (remainder >= {1'b0, B}) begin
                    remainder = remainder - {1'b0, B};
                    result[i] = 1'b1;
                end
                else begin
                    result[i] = 1'b0;
                end
            end
            odd = remainder[7:0];
        end
    end

endmodule