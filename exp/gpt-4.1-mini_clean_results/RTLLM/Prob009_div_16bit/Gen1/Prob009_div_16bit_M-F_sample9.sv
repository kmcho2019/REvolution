module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,  // quotient
    output reg  [15:0] odd      // remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Combinationally latch inputs into internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic: shift and subtract approach
    always @(*) begin
        reg [15:0] quotient;
        reg [15:0] remainder;
        integer i;

        quotient = 16'b0;
        remainder = 16'b0;

        // Iterate from MSB to LSB of dividend
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            remainder = (remainder << 1) | ((a_reg >> i) & 1'b1);

            // Extract upper 8 bits of remainder for comparison with divisor
            if (remainder[15:8] >= b_reg) begin
                // Subtract divisor shifted to upper bits from remainder
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