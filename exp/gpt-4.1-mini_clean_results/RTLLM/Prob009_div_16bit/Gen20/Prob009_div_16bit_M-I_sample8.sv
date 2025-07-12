module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (lower 8 bits valid)
);

    // Internal registers for division process
    reg [7:0] remainder;
    reg [15:0] quotient;
    integer i;

    always @(*) begin
        remainder = 8'd0;
        quotient = 16'd0;
        // Process bits from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, append next bit of dividend
            remainder = {remainder[6:0], A[i]};
            // If remainder >= divisor, subtract and set quotient bit
            if (remainder >= B) begin
                remainder = remainder - B;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
    end

    always @(*) begin
        result = quotient;
        odd = {8'd0, remainder};
    end

endmodule