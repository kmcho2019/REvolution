module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // First always block: latch inputs into combinational regs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    integer i;
    reg [8:0] rem [0:16];  // 9-bit remainder stages, stage 0 to 16
    reg [15:0] quotient_reg;

    always @(*) begin
        rem[0] = 9'd0;
        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder left by 1, bring in next dividend bit
            rem[i+1] = 9'd0; // default assign to prevent latches
            quotient_reg[15 - i] = 1'b0; // default assign

            // Temporary shifted remainder: rem[i] << 1 plus next dividend bit
            // Concatenate rem[i][7:0] and a_reg bit to get 9 bits total
            // rem[i][8] is the sign bit from previous step, not needed to shift in dividend bit
            // Because rem[i] is 9-bit, but highest bit used as borrow sign.
            // Shift left by 1 means {rem[i][7:0], a_reg[15 - i]}
            // Then try to subtract divisor b_reg.
            
            // Compute shifted remainder
            // Use temporary variable to hold intermediate
            // Since inside always block, use temporary variables:
            reg [8:0] rem_shifted;
            reg [8:0] diff;

            rem_shifted = {rem[i][7:0], a_reg[15 - i]};
            diff = rem_shifted - {1'b0, b_reg};

            if (diff[8] == 1'b0) begin
                // no borrow => quotient bit = 1, remainder updated to diff[7:0]
                quotient_reg[15 - i] = 1'b1;
                rem[i+1] = diff;
            end else begin
                // borrow => quotient bit = 0, remainder unchanged shifted remainder
                quotient_reg[15 - i] = 1'b0;
                rem[i+1] = rem_shifted;
            end
        end

        result = quotient_reg;
        odd = {8'd0, rem[16][7:0]};
    end

endmodule