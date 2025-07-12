module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // Internal registered copies of inputs for stable inputs during combinational processing
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational block: latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational block: perform division using remainder shift and compare approach
    always @(*) begin
        reg [15:0] remainder_shift_reg;   // Holds remainder and bits yet to be processed
        reg [15:0] quotient_temp;         // Temporary quotient register
        reg [7:0]  top_bits;              // Extracted top 8 bits of remainder
        integer    i;

        // Initialize remainder_shift_reg with dividend
        remainder_shift_reg = a_reg;
        quotient_temp = 16'b0;

        // Iterate over each bit from MSB to LSB
        // At each iteration:
        // 1. Extract top 8 bits of remainder_shift_reg (bits 15:8)
        // 2. Compare with divisor b_reg
        // 3. If top_bits >= divisor, subtract divisor from top_bits, update remainder_shift_reg
        // 4. Set quotient bit accordingly
        // 5. Shift remainder_shift_reg left by 1 to prepare next iteration

        for (i = 15; i >= 0; i = i - 1) begin
            // Extract top 8 bits of current remainder
            top_bits = remainder_shift_reg[15:8];

            // Compare top_bits with divisor
            if (top_bits >= b_reg) begin
                // Subtract divisor
                top_bits = top_bits - b_reg;

                // Update remainder_shift_reg bits 15:8 with new remainder part
                remainder_shift_reg[15:8] = top_bits;

                // Set current quotient bit to 1
                quotient_temp[i] = 1'b1;
            end else begin
                // No subtraction, quotient bit = 0
                quotient_temp[i] = 1'b0;
            end

            // Shift remainder_shift_reg left by 1 bit to bring down next dividend bit
            // The shift inserts 0 at LSB
            remainder_shift_reg = {remainder_shift_reg[14:0], 1'b0};
        end

        // Final quotient and remainder assignment
        result = quotient_temp;
        // remainder is the lower 8 bits of remainder_shift_reg (upper 8 bits zero-extended)
        odd = {8'b0, remainder_shift_reg[15:8]}; 
        // Note: remainder is taken from bits [15:8] since after last shift,
        // the remainder is in the upper byte part of remainder_shift_reg
    end

endmodule