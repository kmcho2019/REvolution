module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs combinationally as required
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic combinationally
    always @(*) begin
        reg [7:0] remainder;
        reg [15:0] quotient;
        reg [23:0] work_reg;  // remainder(8) + dividend bits(16)

        integer i;

        // Initialize work_reg with dividend in lower 16 bits, remainder (8 bits) zero in upper bits
        work_reg = {8'd0, a_reg};

        quotient = 16'd0;

        // Iterate for each bit of quotient from MSB to LSB
        // At each step: extract top 8 bits of work_reg (bits 23 downto 16), compare with divisor
        // If >= divisor, subtract divisor and set quotient bit, else clear quotient bit
        // Then shift work_reg left by 1 to bring down next dividend bit

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = work_reg[23:16];        // Extract top 8 bits as remainder
            if (remainder >= b_reg && b_reg != 0) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end

            // Update work_reg top 8 bits with remainder after subtraction or no change
            work_reg[23:16] = remainder;

            // Shift work_reg left by 1 bit, dropping the top bit and bringing down next dividend bit in LSB
            // Since dividend is in lower 16 bits of work_reg initially, shifting left advances dividend bits into remainder
            work_reg = work_reg << 1;
        end

        result = quotient;
        // After 16 shifts, remainder is in top 8 bits (bits 23 downto 16) shifted out by last iteration,
        // but after last shift, remainder is in bits 23:16 again, so extract it
        odd = {8'd0, work_reg[23:16]};
    end

endmodule