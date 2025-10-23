module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (zero-extended)
);

    // Internal registers to hold inputs (combinationally updated)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Temporary registers for division process
    reg [8:0] remainder;  // 9-bit remainder to hold up to divisor + borrow
    integer i;

    // First always block: latch inputs combinationally
    always @* begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    always @* begin
        remainder = 9'd0;  // Initialize remainder to 0
        result = 16'd0;    // Initialize quotient to 0

        // Iterate over each bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in next bit from a_reg
            remainder = {remainder[7:0], a_reg[i]};

            // Compare remainder with divisor (extended to 9 bits)
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                result[i] = 1'b1; // Set quotient bit
            end
            else begin
                result[i] = 1'b0; // Clear quotient bit
            end
        end

        // Zero-extend remainder to 16 bits for output
        odd = {7'd0, remainder[7:0]};
    end

endmodule