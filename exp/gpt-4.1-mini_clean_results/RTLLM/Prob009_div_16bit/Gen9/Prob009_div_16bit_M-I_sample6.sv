module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers (combinationally)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic on latched inputs
    always @(*) begin
        integer i;
        reg [7:0] remainder;
        reg [15:0] quotient;

        remainder = 8'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            remainder = {remainder[6:0], a_reg[i]};
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder};  // zero-extend remainder to 16 bits
    end

endmodule