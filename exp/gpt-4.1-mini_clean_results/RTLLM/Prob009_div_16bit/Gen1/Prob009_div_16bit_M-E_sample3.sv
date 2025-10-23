module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Capture inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        integer i;
        reg [7:0] remainder;    // Current remainder (8-bit)
        reg [15:0] quotient;    // Accumulated quotient
        reg [8:0]  dividend_segment; // 9-bit segment: remainder concatenated with next dividend bit

        quotient = 16'b0;
        remainder = a_reg[15:8];  // Initialize remainder with upper 8 bits of dividend

        // Process lower 8 bits of dividend one by one
        for (i = 7; i >= 0; i = i - 1) begin
            // Bring down next dividend bit to remainder (MSB shift)
            dividend_segment = {remainder, a_reg[i]}; // 9 bits

            if (dividend_segment >= b_reg) begin
                dividend_segment = dividend_segment - b_reg;
                quotient[i + 8] = 1'b1;  // Set corresponding quotient bit (upper 8 bits)
            end else begin
                quotient[i + 8] = 1'b0;
            end

            remainder = dividend_segment[7:0]; // Update remainder to lower 8 bits of the subtraction result
        end

        // The lower 8 bits of quotient come from initial comparison of upper bits, which in this approach are zeros
        // So we shift quotient left by 8 for upper bits processed, the lower bits are zeros
        // But problem wants 16-bit quotient, all bits set by above loop:
        // Actually, the above loop sets quotient bits [15:8], lower bits [7:0] should be 0
        // To represent quotient aligned with dividend bits, we shift quotient accordingly

        // Since we only set bits [15:8] in loop, set bits [7:0] to zero explicitly
        // Because the problem wants 16-bit quotient
        for (i = 7; i >= 0; i = i -1) begin
            quotient[i] = 1'b0;
        end

        result = quotient;
        odd = {8'b0, remainder}; // Remainder in lower 8 bits, upper 8 bits zero
    end

endmodule