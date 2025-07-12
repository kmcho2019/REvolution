module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // First always block: combinational capture of inputs into internal regs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    integer i;
    reg [15:0] quotient_temp;
    reg [8:0] remainder;  // 9 bits to accommodate remainder during shifting and subtraction

    always @(*) begin
        quotient_temp = 16'd0;
        remainder = 9'd0;

        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder left by 1 and bring next dividend bit
            remainder = {remainder[7:0], a_reg[15 - i]};

            // If remainder >= divisor, subtract and set quotient bit
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient_temp[15 - i] = 1'b1;
            end else begin
                quotient_temp[15 - i] = 1'b0;
            end
        end

        result = quotient_temp;
        // Remainder lower 8 bits valid, upper 8 bits zero
        odd = {8'd0, remainder[7:0]};
    end

endmodule