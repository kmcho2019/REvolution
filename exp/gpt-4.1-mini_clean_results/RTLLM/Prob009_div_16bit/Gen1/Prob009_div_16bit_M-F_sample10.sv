module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational division
    always @(*) begin
        reg [15:0] quotient;
        reg [15:0] remainder;
        integer i;

        quotient = 16'b0;
        remainder = 16'b0;

        // Iterate from MSB to LSB of dividend
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down the next bit from a_reg
            remainder = (remainder << 1) | ((a_reg >> i) & 1'b1);

            // Extract upper 8 bits of remainder for comparison with divisor
            // If upper 8 bits >= b_reg, subtract divisor aligned to upper bits and set quotient bit
            if (remainder[15:8] >= b_reg) begin
                remainder = remainder - (b_reg << 8);
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule