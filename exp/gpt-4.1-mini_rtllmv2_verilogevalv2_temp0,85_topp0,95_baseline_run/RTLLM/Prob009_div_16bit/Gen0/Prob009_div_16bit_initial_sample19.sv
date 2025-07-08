module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs in a combinational always block
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic using restoring division method
    always @(*) begin
        // Initialize remainder and quotient
        reg [15:0] remainder;
        reg [15:0] quotient;
        integer i;

        remainder = 0;
        quotient = 0;

        // Iterate over each bit from MSB to LSB
        // Each step left-shifts remainder by 1, brings down next bit of a_reg,
        // compares remainder with divisor b_reg, and sets quotient bit accordingly.
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next bit of dividend
            remainder = {remainder[14:0], a_reg[i]};

            // Compare remainder with divisor b_reg (8-bit)
            // Since remainder is 16-bit, but divisor is 8-bit,
            // we consider remainder upper bits only for comparison.
            // However, here remainder is always shifted and stored in 16 bits,
            // so we compare the full remainder with zero-extended divisor.

            if (remainder[15:0] >= {{8{1'b0}}, b_reg}) begin
                remainder = remainder - {{8{1'b0}}, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule