module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // Combinational division using restoring division algorithm
    always @(*) begin
        integer i;
        reg [7:0] remainder;    // 8-bit remainder register
        reg [15:0] quotient;    // 16-bit quotient register
        reg [7:0] divisor;      // 8-bit divisor copy

        divisor = B;
        remainder = 8'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 and input next bit of dividend
            remainder = {remainder[6:0], A[i]};
            
            // If remainder >= divisor, subtract divisor and set quotient bit
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Zero-extend remainder (8 bits) to 16 bits for output
        odd = {8'd0, remainder};
    end

endmodule