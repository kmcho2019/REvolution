module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    // Combinational division logic in one always block
    always @(*) begin
        reg [15:0] quotient;
        reg [15:0] remainder;
        reg [7:0]  divisor;
        integer i;

        quotient = 16'b0;
        remainder = 16'b0;
        divisor = B;

        // Iterate from MSB to LSB of dividend
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next dividend bit
            remainder = {remainder[14:0], A[i]};

            // Extract upper 8 bits for comparison
            if (remainder[15:8] >= divisor) begin
                remainder[15:8] = remainder[15:8] - divisor;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule