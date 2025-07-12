module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers (combinational style: sensitive to A or B)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic: iterative shift-subtract division
    always @(*) begin
        integer i;
        reg [8:0] remainder;  // 9-bit remainder: 1 extra bit for subtraction borrow
        reg [15:0] quotient_tmp;

        remainder = 9'd0;
        quotient_tmp = 16'd0;

        // Iterate over each bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in current dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Compare remainder with divisor b_reg
            if (remainder[8:0] >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        odd = {8'd0, remainder[7:0]}; // remainder is lower 8 bits; upper 8 bits zero
    end

endmodule