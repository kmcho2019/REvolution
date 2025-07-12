module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,  // quotient
    output reg  [15:0] odd      // remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs combinationally (per problem requirement)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        reg [15:0] quotient;
        reg [15:0] remainder;
        integer i;

        quotient = 16'b0;
        remainder = 16'b0;

        if (b_reg == 0) begin
            // Divisor zero: define quotient and remainder as zero
            quotient = 16'b0;
            remainder = 16'b0;
        end else begin
            // Perform division bit-by-bit from MSB to LSB
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left by 1 and bring down next bit of dividend
                remainder = (remainder << 1) | ((a_reg >> i) & 1'b1);

                // Compare remainder with divisor
                if (remainder[7:0] >= b_reg) begin
                    // Subtract divisor from lower 8 bits of remainder
                    remainder = remainder - {8'b0, b_reg};
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule