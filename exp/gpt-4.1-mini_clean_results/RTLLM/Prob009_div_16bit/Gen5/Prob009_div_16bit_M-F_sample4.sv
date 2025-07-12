module div_16bit (
    input  wire [15:0] A,     // Dividend
    input  wire [7:0]  B,     // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (zero-extended)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    integer i;
    reg [7:0] remainder;
    reg [8:0] quotient_bits; // 9 quotient bits as per division steps

    // Latch inputs into registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic combinational block
    always @(*) begin
        quotient_bits = 9'd0;
        remainder = a_reg[15:8]; // Start with highest 8 bits of dividend

        if (b_reg == 8'd0) begin
            // Division by zero, set quotient and remainder zero
            quotient_bits = 9'd0;
            remainder = 8'd0;
        end else begin
            // Perform 9-step division loop (from highest quotient bit down to lowest)
            for (i = 8; i >= 0; i = i - 1) begin
                if (remainder >= b_reg) begin
                    remainder = remainder - b_reg;
                    quotient_bits[i] = 1'b1;
                end else begin
                    quotient_bits[i] = 1'b0;
                end

                // Shift remainder left by 1 bit and bring in next dividend bit if not last iteration
                if (i > 0) begin
                    remainder = {remainder[6:0], a_reg[i - 1]};
                end
            end
        end

        // Assign quotient_bits to lower 9 bits of the 16-bit result, upper bits zero
        result = {7'd0, quotient_bits};
        // Zero-extend remainder to 16 bits
        odd = {8'd0, remainder};
    end

endmodule