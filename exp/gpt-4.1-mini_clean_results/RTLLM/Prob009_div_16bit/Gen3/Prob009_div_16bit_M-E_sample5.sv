module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient output
    output reg  [15:0] odd      // 16-bit remainder output (zero-extended)
);

    reg [15:0] a_reg; // internal register for dividend
    reg [7:0]  b_reg; // internal register for divisor

    reg [8:0] quotient_temp;   // 9-bit quotient (for 9 iterations)
    reg [7:0] partial_dividend; // 8-bit partial dividend/remainder
    reg [3:0] i;                // loop counter for iterations 0..8

    // Latch inputs combinationally into internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division process combinational always block
    always @(*) begin
        // Initialization:
        // Extract highest 8 bits from dividend as initial partial dividend
        partial_dividend = a_reg[15:8];
        quotient_temp = 9'd0;

        // Perform 9 steps:
        // step 0 compares partial_dividend with divisor,
        // then concatenates the next bit from dividend at bit 7 down to 0 in steps 1..8
        for (i = 0; i < 9; i = i + 1) begin
            if (partial_dividend >= b_reg) begin
                partial_dividend = partial_dividend - b_reg;
                quotient_temp[8 - i] = 1'b1;
            end else begin
                quotient_temp[8 - i] = 1'b0;
            end

            // Concatenate the next dividend bit if not on last iteration
            if (i < 8) begin
                // Shift partial_dividend left by 1, bring down next dividend bit from a_reg
                partial_dividend = {partial_dividend[6:0], a_reg[7 - i]};
            end
            // On i == 8, no further bits to bring down
        end

        // Output assignments:
        // Quotient_temp is 9-bit: place in upper bits of result, LSB bits zeroed
        // To match 16-bit result, shift quotient_temp 7 bits left:
        // quotient_temp[8] corresponds to result[15], down to quotient_temp[0] -> result[7]
        // lower 7 bits are zero.
        result = {quotient_temp, 7'd0};

        // zero-extend remainder to 16-bit odd output
        odd = {8'd0, partial_dividend};
    end

endmodule