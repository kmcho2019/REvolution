module div_16bit(
    input  [15:0] A,         // 16-bit dividend
    input  [7:0]  B,         // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    integer i;

    // First always block: capture inputs into stable registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: perform division combinationally
    always @(*) begin
        reg [7:0] remainder;    // 8-bit remainder register
        reg [15:0] quotient_tmp; // temporary quotient register

        remainder = 8'd0;
        quotient_tmp = 16'd0;

        // Iterate from MSB to LSB (bit 15 downto 0)
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in next dividend bit a_reg[i]
            remainder = {remainder[6:0], a_reg[i]};

            // Compare remainder with divisor
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        // Assign outputs
        result = quotient_tmp;
        odd = {8'd0, remainder}; // remainder in lower 8 bits, upper 8 bits zero
    end

endmodule