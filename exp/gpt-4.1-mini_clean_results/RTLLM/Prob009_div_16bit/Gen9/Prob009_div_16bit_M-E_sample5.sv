module div_16bit (
    input  wire [15:0] A,        // 16-bit dividend
    input  wire [7:0]  B,        // 8-bit divisor
    output reg  [15:0] result,   // 16-bit quotient
    output reg  [15:0] odd       // 16-bit remainder
);

    // Latch inputs into internal registers
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division combinational logic
    always @(*) begin
        reg [15:0] quotient_tmp;
        reg [15:0] dividend_tmp;
        reg [7:0]  remainder_tmp;
        integer    i;

        quotient_tmp = 16'b0;
        dividend_tmp = a_reg;
        remainder_tmp = 8'b0;

        // Process 16 bits of dividend, one bit at a time
        for (i = 15; i >= 0; i = i - 1) begin
            // Left shift remainder by 1 and bring down next dividend bit (MSB first)
            remainder_tmp = {remainder_tmp[6:0], dividend_tmp[15]};

            // Shift dividend left by 1 to bring next bit into MSB position
            dividend_tmp = {dividend_tmp[14:0], 1'b0};

            // Compare remainder with divisor
            if (remainder_tmp >= b_reg) begin
                remainder_tmp = remainder_tmp - b_reg;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        // Remainder zero-extended to 16 bits (upper 8 bits zero)
        odd = {8'b0, remainder_tmp};
    end

endmodule