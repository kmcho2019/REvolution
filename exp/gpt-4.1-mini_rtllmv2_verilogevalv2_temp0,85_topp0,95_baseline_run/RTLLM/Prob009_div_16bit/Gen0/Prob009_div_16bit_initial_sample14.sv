module div_16bit (
    input  wire [15:0] A,    // 16-bit dividend
    input  wire [7:0]  B,    // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder (only lower 8 bits valid)
);

    reg [15:0] a_reg; // Registered dividend
    reg [7:0]  b_reg; // Registered divisor

    // Load inputs into registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        integer i;
        reg [15:0] remainder; // Will hold partial remainder, max 16 bits to shift in bits
        reg [15:0] quotient;

        remainder = 0;
        quotient = 0;

        // Iterate over each bit of dividend from MSB to LSB
        // At each step, shift remainder left by 1 and bring down next dividend bit
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[14:0], a_reg[i]}; // shift left by 1, bring down bit i

            if (remainder[15:8] >= b_reg) begin
                // Compare upper 8 bits of remainder with divisor
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder; // remainder stored in 16 bits, upper bits zero or partial but only lower 8 bits matter
    end

endmodule