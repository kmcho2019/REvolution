module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    always @(*) begin
        reg [8:0] rem = 0;  // 9-bit remainder (8+1 for comparison)
        integer i;
        
        // Handle zero divisor case
        if (B == 8'b0) begin
            result = 16'b0;
            odd = 8'b0;
        end else begin
            rem = 0;
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left and add next bit
                rem = {rem[7:0], A[i]};
                
                // Compare and subtract if possible
                if (rem >= {1'b0, B}) begin
                    rem = rem - {1'b0, B};
                    result[i] = 1'b1;
                end else begin
                    result[i] = 1'b0;
                end
            end
            odd = rem[7:0];
        end
    end

endmodule