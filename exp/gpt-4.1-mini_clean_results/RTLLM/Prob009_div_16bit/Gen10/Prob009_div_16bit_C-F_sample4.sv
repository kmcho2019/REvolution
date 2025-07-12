module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    // Internal registers to latch inputs (combinationally)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational block: latch inputs into internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational block: perform restoring division
    always @(*) begin
        integer i;
        reg [8:0] remainder;      // 9-bit remainder to hold shifted bits and carry
        reg [15:0] quotient;      // 16-bit quotient result
        reg [8:0] divisor_ext;    // Divisor extended to 9 bits for comparison

        // Initialize remainder and quotient
        remainder   = 9'b0;
        quotient    = 16'b0;
        divisor_ext = {1'b0, b_reg}; // Zero-extend divisor to 9 bits

        // Iterate over dividend bits from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit and bring down the current dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            
            // Compare remainder with divisor
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Assign outputs
        result = quotient;
        // Output remainder zero-extended from lower 8 bits of remainder
        odd    = {8'b0, remainder[7:0]};
    end

endmodule