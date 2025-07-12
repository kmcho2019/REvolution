module div_16bit (
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First always block: latch inputs combinationally into registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational non-restoring division
    always @(*) begin
        integer i;
        reg [16:0] remainder;      // 17-bit remainder to hold shifted bits and subtraction
        reg [15:0] quotient;       // 16-bit quotient
        reg [8:0]  divisor_ext;    // divisor extended to 9 bits

        remainder   = 17'b0;
        quotient    = 16'b0;
        divisor_ext = {1'b0, b_reg}; // 9-bit extended divisor

        // Non-restoring division-like iterative logic:
        // Shift in dividend bits MSB first, then conditionally subtract divisor
        // If remainder >= divisor, subtract divisor and set quotient bit, else do not subtract.
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = remainder << 1;          // Shift remainder left by 1
            remainder[0] = a_reg[i];              // Bring down current dividend bit

            // Compare upper bits of remainder with divisor_ext
            if (remainder[16:8] >= divisor_ext) begin
                remainder[16:8] = remainder[16:8] - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Assign outputs
        result = quotient;

        // Remainder is the upper 9 bits of remainder; output zero-extended to 16 bits
        odd = {7'b0, remainder[16:8]};
    end

endmodule