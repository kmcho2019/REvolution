module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    integer i;
    reg [8:0] remainder;    // 9-bit remainder: 8 bits divisor + 1 extra bit for shifting
    reg [15:0] quotient;

    // Latch inputs into registers (combinational latching)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic implementing the specified algorithm
    always @(*) begin
        remainder = 0;
        quotient = 0;

        // Iterate from MSB (bit 15) down to LSB (bit 0)
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and input next dividend bit at LSB
            remainder = {remainder[7:0], a_reg[i]};

            // Compare the upper 8 bits of remainder with divisor b_reg
            if (remainder[8:1] >= b_reg) begin
                // Subtract divisor from the upper bits of remainder
                remainder[8:1] = remainder[8:1] - b_reg;
                // Set quotient bit at position i to 1
                quotient[i] = 1'b1;
            end else begin
                // Set quotient bit at position i to 0
                quotient[i] = 1'b0;
            end
        end

        // Assign outputs
        result = quotient;
        // Remainder in lower 8 bits; upper 8 bits zero-padded
        odd = {8'd0, remainder[8:1]};
    end

endmodule