module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First always block: register inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: perform division combinationally
    // Use a shift-subtract restoring division approach:
    // remainder width is 16 bits, quotient width is 16 bits
    // At each step:
    //   - shift remainder left 1 bit and bring down next dividend bit
    //   - compare remainder with divisor
    //   - if remainder >= divisor, subtract divisor and set quotient bit
    //   - else quotient bit 0
    always @(*) begin
        integer i;
        reg [15:0] remainder;
        reg [15:0] quotient;
        reg [7:0] divisor;
        reg [7:0] rem_high;

        remainder = 0;
        quotient  = 0;
        divisor   = b_reg;

        // The division process:
        // For 16 iterations, process from MSB to LSB of a_reg
        for(i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of a_reg
            remainder = {remainder[14:0], a_reg[i]};

            // Extract upper 8 bits of remainder for comparison
            rem_high = remainder[15:8];

            // Compare and update remainder and quotient
            if(rem_high >= divisor) begin
                // remainder = remainder - (divisor shifted left 8 bits)
                // Because divisor is 8-bit aligned at remainder[15:8]
                remainder = remainder - ( {divisor,8'b0} >> 8); 
                // Actually, to subtract divisor correctly from the upper bits,
                // we need to subtract divisor shifted left by 8 bits

                // The above shift approach needs correction:
                // remainder is 16-bit, divisor is 8-bit
                // We need to subtract divisor shifted to the upper bits of remainder

                // Let's do: remainder - (divisor << 8)

                remainder = remainder - (divisor << 8);

                // Set quotient bit i to 1
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd    = remainder;
    end

endmodule