module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    // Internal registers to latch inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Divider logic variables
    reg [23:0] remainder;  // 24-bit remainder register
    reg [15:0] quotient;

    integer i;

    // Input latching always block
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic always block (combinational)
    always @(*) begin
        quotient = 16'b0;
        remainder = 24'b0;

        if (b_reg == 8'b0) begin
            // Division by zero: outputs zero quotient and remainder
            quotient = 16'b0;
            remainder = 24'b0;
        end else begin
            // Initialize remainder upper bits with highest 8 bits of dividend
            remainder[23:16] = a_reg[15:8];
            remainder[15:0]  = 16'b0;

            for (i = 15; i >= 0; i = i - 1) begin
                // Compare top 8 bits of remainder with divisor
                if (remainder[23:16] >= b_reg) begin
                    // Subtract divisor from top 8 bits
                    remainder[23:16] = remainder[23:16] - b_reg;
                    quotient[i] = 1'b1;
                end else begin
                    quotient[i] = 1'b0;
                end

                // Shift remainder left by 1 and bring in next dividend bit at LSB
                // For next iteration (if i>0), concatenation with the next dividend bit
                remainder = {remainder[22:0], a_reg[i]};
            end
        end

        result = quotient;
        // Remainder is top 8 bits of remainder after last shift step (bits 23:16)
        // Zero-extend to 16 bits for output
        odd = {8'b0, remainder[23:16]};
    end

endmodule