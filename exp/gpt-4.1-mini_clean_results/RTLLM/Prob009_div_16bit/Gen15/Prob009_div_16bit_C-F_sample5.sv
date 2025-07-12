module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Combinational registers to latch inputs (as required)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    integer i;
    reg [7:0] remainder;
    reg [15:0] quotient;

    always @(*) begin
        remainder = 8'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in next dividend bit
            // Create 9-bit value for subtraction (remainder extended + new bit)
            // extended remainder with appended current bit of dividend
            // The subtraction also uses 9 bits to detect borrow via MSB
            reg [8:0] rem_shifted_ext;
            reg [8:0] diff;

            rem_shifted_ext = {remainder, a_reg[i]};
            diff = rem_shifted_ext - {1'b0, b_reg};

            if (diff[8] == 1'b0) begin
                // No borrow, divisor fits
                quotient[i] = 1'b1;
                remainder = diff[7:0];
            end else begin
                // Borrow: divisor too big
                quotient[i] = 1'b0;
                remainder = rem_shifted_ext[7:0];
            end
        end

        result = quotient;
        // remainder zero-extended to 16 bits on output port odd
        odd = {8'd0, remainder};
    end

endmodule