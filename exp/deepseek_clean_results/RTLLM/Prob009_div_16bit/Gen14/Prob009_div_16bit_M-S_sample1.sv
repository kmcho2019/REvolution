module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    wire zero_divisor = (B == 8'b0);
    reg [7:0] remainder;
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        remainder = 8'b0;
        quotient = 16'b0;
        
        if (!zero_divisor) begin
            remainder = A[15:8];  // Start with upper 8 bits
            
            for (i = 15; i >= 0; i = i - 1) begin
                // Compare and subtract if possible
                if (remainder >= B) begin
                    remainder = remainder - B;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
                
                // Shift in next bit if not last iteration
                if (i > 0) begin
                    remainder = {remainder[6:0], A[i-1]};
                end
            end
        end
    end

    assign result = zero_divisor ? 16'b0 : quotient;
    assign odd = zero_divisor ? A[7:0] : remainder;

endmodule