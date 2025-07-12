module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [15:0] divisor_ext;
    integer i;

    always @(*) begin
        // Pre-compute zero-extended divisor once
        divisor_ext = {8'b0, B};
        
        // Initialize registers
        remainder = 16'b0;
        quotient = 16'b0;
        
        // Perform division
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left and bring down next dividend bit
            remainder = {remainder[14:0], A[i]};
            
            // Compare and subtract if possible
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        
        // Assign outputs
        result = quotient;
        odd = remainder;
    end

endmodule