module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // Perform combinational restoring division algorithm directly on inputs
    always @(*) begin
        integer i;
        reg [8:0] remainder;       // 9-bit remainder (1 bit wider than divisor)
        reg [15:0] quotient;       // 16-bit quotient
        reg [8:0] divisor_ext;     // 9-bit zero-extended divisor

        remainder   = 9'b0;
        quotient    = 16'b0;
        divisor_ext = {1'b0, B};   // zero-extend divisor to 9 bits

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring down current dividend bit
            remainder = {remainder[7:0], A[i]};

            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // remainder is 9-bit; lower 8 bits valid. Zero-extend to 16 bits.
        odd = {8'b0, remainder[7:0]};
    end

endmodule