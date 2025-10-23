module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Capture inputs into registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform division combinationally
    always @(*) begin
        reg [8:0] remainder;
        reg [15:0] quotient;
        integer i;

        remainder = 9'd0;
        quotient = 16'd0;

        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend (MSB first)
            remainder = {remainder[7:0], a_reg[15 - i]};
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[15 - i] = 1'b1;
            end else begin
                quotient[15 - i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]}; // zero-extend remainder to 16 bits
    end

endmodule