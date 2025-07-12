module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Registers to hold inputs combinationally
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Internal variables for division
    integer i;
    reg [15:0] remainder;  // wider remainder to shift in bits
    reg [15:0] quotient;

    // Always block 1: combinational register input latch
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Always block 2: combinational division logic
    always @(*) begin
        remainder = 0;
        quotient  = 0;
        // Iterate over each bit of the dividend, MSB first
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1, bring in next dividend bit
            remainder = {remainder[14:0], a_reg[i]};
            // Compare top 8 bits of remainder with divisor
            if (remainder[15:8] >= b_reg) begin
                // Subtract divisor from top 8 bits
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Output assignments
        result = quotient;
        odd = {8'b0, remainder[7:0]};  // Remainder is lower 8 bits after division
    end

endmodule