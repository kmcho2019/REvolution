module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate remainder and quotient
    reg [8:0] remainder;  // 9-bit to handle overflow
    reg [15:0] quotient;
    
    // Combinational logic
    always @(*) begin
        remainder = 9'b0;
        quotient = 16'b0;
        
        // Process each bit from MSB to LSB
        for (integer i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left and bring in next bit
            remainder = {remainder[7:0], A[i]};
            
            // Compare and subtract if possible
            if (remainder >= {1'b0, B}) begin
                remainder = remainder - {1'b0, B};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
    end
    
    // Output assignments with zero-division check
    assign result = (B == 8'b0) ? 16'b0 : quotient;
    assign odd = (B == 8'b0) ? 8'b0 : remainder[7:0];

endmodule