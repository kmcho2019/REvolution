module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Capture inputs into registers (combinational style)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic combinational block
    always @(*) begin
        reg [8:0] remainder;        // 9 bits to hold remainder (extra bit for borrow)
        reg [15:0] quotient_tmp;
        integer i;

        remainder = 9'd0;
        quotient_tmp = 16'd0;

        // Iterative division algorithm:
        // At each iteration, shift remainder left 1, bring in next dividend bit,
        // subtract divisor if possible, set quotient bit accordingly
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, input next bit from dividend
            remainder = {remainder[7:0], a_reg[i]};
            // Compare remainder with divisor
            if (remainder[8:1] >= b_reg) begin
                remainder[8:1] = remainder[8:1] - b_reg;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
            // Keep remainder[0] as the extra bit (could be zero)
            remainder[0] = 1'b0; // Clear LSB after subtraction to keep consistent width
        end

        result = quotient_tmp;
        // remainder[8:1] contains remainder after all iterations, place in lower bits of odd, upper bits zero
        odd = {8'd0, remainder[8:1]};
    end

endmodule