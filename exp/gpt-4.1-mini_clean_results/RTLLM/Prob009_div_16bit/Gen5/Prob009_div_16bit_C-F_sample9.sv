module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // Internal registered copies of inputs to isolate signals and aid synthesis
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First always block: latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational restoring division
    always @(*) begin
        integer i;
        reg [8:0] remainder;       // 9-bit remainder to hold divisor width + carry
        reg [15:0] quotient;       // 16-bit quotient
        reg [8:0] divisor_ext;     // Divisor zero-extended to 9 bits

        remainder = 9'd0;
        quotient  = 16'd0;
        divisor_ext = {1'b0, b_reg}; // extend divisor to 9 bits for proper comparison

        // Perform restoring division algorithm over 16 bits
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit and shift in current dividend bit
            remainder = {remainder[7:0], a_reg[i]};

            // Compare remainder and divisor; subtract if remainder >= divisor
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Assign output quotient and zero-extended remainder
        result = quotient;
        odd = {8'b0, remainder[7:0]};
    end

endmodule