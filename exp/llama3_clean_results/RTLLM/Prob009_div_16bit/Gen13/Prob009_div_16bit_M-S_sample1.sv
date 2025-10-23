module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] divisor;

always @(*) begin
    quotient = 0;
    remainder = A;
    divisor = B;
    
    if (B == 0) begin
        // Handle division by zero
        result = 16'hFFFF;
        odd = 16'hFFFF;
    end else if (B > A[15:8]) begin
        // Handle divisor larger than dividend's higher bits
        result = 0;
        odd = A;
    end else begin
        for (int i = 15; i >= 0; i--) begin
            if (i >= 8) begin
                // Compare divisor with dividend's current bits
                if ({remainder[15:8], 8'd0} >= {8'd0, divisor}) begin
                    // Subtract divisor from dividend's current bits
                    remainder = {remainder[15:8] - divisor, remainder[7:0]};
                    quotient[15 - i] = 1'b1;
                end else begin
                    remainder = {remainder[15:8], remainder[7:0]};
                end
            end else begin
                // Compare divisor with remainder's current bits
                if ({remainder[7:0]} >= {divisor}) begin
                    // Subtract divisor from remainder's current bits
                    remainder = remainder - divisor;
                    quotient[15 - i] = 1'b1;
                end
            end
        end
        
        // Assign the final quotient and remainder
        result = quotient;
        odd = remainder;
    end
end

endmodule