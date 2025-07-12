module div_16bit (
    input  wire [15:0] A,        // Dividend
    input  wire [7:0]  B,        // Divisor
    output reg  [15:0] result,   // Quotient
    output reg  [15:0] odd       // Remainder zero-extended
);

    // Registers to hold inputs combinationally (per problem statement)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Temporary variables for division in second always block
    integer i;
    reg [8:0] remainder; // 9-bit to hold 8-bit remainder + 1 bit shifting room

    // First always block: latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    always @(*) begin
        remainder = 9'd0;
        result = 16'd0;

        // Process all bits starting from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in the next bit of the dividend
            remainder = {remainder[7:0], a_reg[i]};

            // Compare remainder with divisor
            if (remainder[8:1] >= b_reg) begin
                // Subtract divisor from top 8 bits of remainder
                remainder[8:1] = remainder[8:1] - b_reg;
                // Set quotient bit i
                result[i] = 1'b1;
            end else begin
                // Quotient bit i remains 0
                result[i] = 1'b0;
            end
            // The LSB of remainder remains as carry-in for next iteration
        end

        // Output remainder is lower 8 bits of remainder register
        odd = {8'd0, remainder[8:1]};
    end

endmodule