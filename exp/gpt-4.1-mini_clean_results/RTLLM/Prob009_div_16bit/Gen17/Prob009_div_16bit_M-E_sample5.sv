module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Registers to hold inputs combinationally
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First always block: latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: perform division combinationally
    always @(*) begin
        reg [15:0] quotient;
        reg [8:0]  remainder;    // 9 bits to hold shifted remainder plus extra bit
        integer i;

        quotient = 16'd0;
        remainder = 9'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left 1 and bring down the next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Assign outputs
        result = quotient;
        odd = {8'd0, remainder[7:0]};  // Zero-extend remainder to 16 bits
    end

endmodule