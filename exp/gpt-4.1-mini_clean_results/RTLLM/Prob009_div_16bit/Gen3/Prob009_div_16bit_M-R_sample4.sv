module div_16bit(
    input  [15:0] A,       // 16-bit dividend
    input  [7:0]  B,       // 8-bit divisor
    output reg [15:0] result,   // 16-bit quotient
    output reg [15:0] odd       // 16-bit remainder (zero-extended 8-bit remainder)
);

    // Registers to latch inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Temporary variables for division
    reg [7:0] remainder;        // 8-bit remainder (max divisor width)
    reg [15:0] quotient;
    integer i;

    // Latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational division
    always @(*) begin
        remainder = 8'd0;
        quotient = 16'd0;

        // Handle divisor zero case: quotient and remainder zero (could also choose another behavior)
        if (b_reg == 0) begin
            quotient = 16'd0;
            remainder = 8'd0;
        end else begin
            // Division algorithm:
            // For each bit from MSB to LSB
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left by 1 and bring next dividend bit into LSB of remainder
                remainder = (remainder << 1) | a_reg[i];

                // If remainder >= divisor
                if (remainder >= b_reg) begin
                    remainder = remainder - b_reg;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
            end
        end

        // Assign outputs
        result = quotient;

        // zero-extend 8-bit remainder to 16-bit output
        odd = {8'd0, remainder};
    end

endmodule