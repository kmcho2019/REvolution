module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        integer i;
        reg [8:0] remainder;       // 9-bit remainder (to hold divisor + 1 bit)
        reg [15:0] quotient_tmp;

        remainder = 9'd0;
        quotient_tmp = 16'd0;

        // Iterate over each dividend bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], a_reg[i]};  // Shift remainder left by 1, bring in next dividend bit

            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        odd = {7'd0, remainder}; // zero extend remainder to 16 bits, remainder max 9 bits but divisor 8 bits so MSB zero
    end

endmodule