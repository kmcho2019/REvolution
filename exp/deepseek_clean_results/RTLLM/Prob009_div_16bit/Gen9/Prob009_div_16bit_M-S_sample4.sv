module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    reg [8:0] remainder;  // 9-bit remainder (8+1 for comparison)
    integer i;

    always @(*) begin
        remainder = 9'b0;
        
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left and append next dividend bit
            remainder = {remainder[7:0], A[i]};
            
            // Compare and subtract if possible
            if (remainder >= B) begin
                result[i] = 1'b1;
                remainder = remainder - B;
            end else begin
                result[i] = 1'b0;
            end
        end
        
        odd = remainder[7:0];
    end

endmodule