module div_16bit (
    input  wire [15:0] A,        // Dividend
    input  wire [7:0]  B,        // Divisor
    output reg  [15:0] result,   // Quotient
    output reg  [15:0] odd       // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational always block: latch inputs into registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: perform combinational division logic
    always @(*) begin
        integer i;
        reg [8:0] remainder;   // 9-bit remainder to hold carry/borrow and shifted dividend bits
        reg [15:0] quotient_tmp;

        remainder = 9'd0;
        quotient_tmp = 16'd0;

        // Iterate over 16 bits, MSB first
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in the current bit of a_reg
            remainder = {remainder[7:0], a_reg[i]};

            // Compare remainder with divisor (b_reg)
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        // remainder lower 8 bits valid; upper 8 bits zero-extended
        odd = {8'd0, remainder[7:0]};
    end

endmodule