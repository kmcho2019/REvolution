module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    always @(*) begin
        integer i;
        reg [8:0] remainder;   // 9-bit to hold carry and divisor
        reg [15:0] quotient;

        remainder = 0;
        quotient = 0;

        for (i = 0; i < 16; i = i + 1) begin
            remainder = {remainder[7:0], A[15 - i]};
            if (remainder >= {1'b0, B}) begin
                remainder = remainder - {1'b0, B};
                quotient[15 - i] = 1'b1;
            end else begin
                quotient[15 - i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]};
    end

endmodule