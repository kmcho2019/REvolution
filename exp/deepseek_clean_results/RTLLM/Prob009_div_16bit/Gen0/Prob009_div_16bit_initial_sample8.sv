module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    reg [15:0] quotient;
    reg [16:0] remainder; // Extra bit for comparison

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        remainder = 17'b0;
        quotient = 16'b0;
        
        if (b_reg != 8'b0) begin // Only divide if divisor is not zero
            remainder[16:1] = 16'b0;
            remainder[0] = a_reg[15];
            
            for (integer i = 0; i < 16; i = i + 1) begin
                // Shift remainder and quotient left
                remainder = remainder << 1;
                quotient = quotient << 1;
                
                // Bring down next bit
                if (i < 15) begin
                    remainder[0] = a_reg[14 - i];
                end else begin
                    remainder[0] = 1'b0;
                end
                
                // Compare and subtract
                if (remainder[16:9] >= b_reg) begin
                    remainder[16:9] = remainder[16:9] - b_reg;
                    quotient[0] = 1'b1;
                end else begin
                    quotient[0] = 1'b0;
                end
            end
        end
        
        result = quotient;
        odd = remainder[15:0];
    end

endmodule