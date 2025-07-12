module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early termination checks (only once)
    wire zero_divisor = (B == 8'b0);
    wire dividend_zero = (A == 16'b0);
    
    // Main division logic
    reg [7:0] remainder;
    reg [15:0] quotient;
    integer i;
    
    always @(*) begin
        remainder = 8'b0;
        quotient = 16'b0;
        
        if (zero_divisor) begin
            remainder = A[7:0];
            quotient = 16'b0;
        end
        else if (dividend_zero) begin
            remainder = 8'b0;
            quotient = 16'b0;
        end
        else begin
            reg [8:0] current = {1'b0, A[15]};
            
            for (i = 15; i >= 0; i = i - 1) begin
                // Shared comparison and subtraction
                if (current >= {1'b0, B}) begin
                    quotient[i] = 1'b1;
                    remainder = current - B;
                end
                else begin
                    quotient[i] = 1'b0;
                    remainder = current[7:0];
                end
                
                // Prepare next step (shift in next bit)
                if (i > 0) begin
                    current = {remainder, A[i-1]};
                end
            end
        end
    end
    
    assign result = quotient;
    assign odd = remainder;

endmodule