module div_16bit(
    input  [15:0] A,   // Dividend
    input  [7:0]  B,   // Divisor
    output reg [15:0] result,  // Quotient
    output reg [15:0] odd      // Remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs (combinationally)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        integer i;
        reg [15:0] quotient;
        reg [7:0] remainder;

        quotient = 0;
        remainder = a_reg[15:8]; // Take the highest 8 bits first

        for (i = 15; i >= 8; i = i - 1) begin
            // This loop is just for clarity; bits 15 down to 8 already loaded
            // actual bit processing starts below
        end

        // Process bits from 7 down to 0
        for (i = 7; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit from a_reg
            remainder = {remainder[6:0], a_reg[i]};
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // The top 8 quotient bits correspond to the initial remainder comparison
        // We must also set quotient[15:8]
        // The division algorithm sets quotient bits as the iteration progresses,
        // but above we only set bits [7:0].
        // We need to simulate the top bits as well:
        // Actually, the initial remainder is a_reg[15:8]. So we need to do the division for bits 15:8 too.

        // To properly implement the full 16-bit quotient, we simulate from bit 15 down to 0:

        // Revised approach: full algorithm:
        reg [15:0] q_temp;
        reg [7:0] r_temp;

        r_temp = 0;
        q_temp = 0;
        // Loop from bit 15 down to 0
        for (i = 15; i >= 0; i = i - 1) begin
            r_temp = {r_temp[6:0], a_reg[i]};
            if (r_temp >= b_reg) begin
                r_temp = r_temp - b_reg;
                q_temp[i] = 1'b1;
            end else begin
                q_temp[i] = 1'b0;
            end
        end

        quotient = q_temp;
        remainder = r_temp;

        result = quotient;
        odd = {8'b0, remainder};
    end

endmodule