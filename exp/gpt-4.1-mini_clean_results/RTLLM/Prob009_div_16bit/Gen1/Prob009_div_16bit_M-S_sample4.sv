module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    integer i;
    reg [15:0] remainder;
    reg [15:0] quotient;

    always @(*) begin
        remainder = 16'b0;
        quotient = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[14:0], A[i]};   // Shift in next dividend bit
            if (remainder[15:8] >= B) begin
                remainder[15:8] = remainder[15:8] - B;  // Subtract divisor from upper bits
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule