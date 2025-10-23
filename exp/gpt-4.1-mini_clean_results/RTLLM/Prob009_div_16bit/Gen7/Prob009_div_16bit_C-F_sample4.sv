module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;   // Registered dividend (combinational latch)
    reg [7:0]  b_reg;   // Registered divisor (combinational latch)

    // First combinational always block: latch inputs into internal regs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: perform restoring division
    always @(*) begin
        integer i;
        reg [8:0] remainder;      // 9-bit remainder: 8-bit width plus carry bit
        reg [15:0] quotient;      // 16-bit quotient
        reg [8:0] divisor_ext;    // Divisor zero-extended to 9 bits for comparison

        remainder = 9'b0;
        quotient  = 16'b0;
        divisor_ext = {1'b0, b_reg}; // zero-extend divisor to 9 bits

        // Iteratively shift in dividend bits and subtract divisor when possible
        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder[7:0]}; // zero-extend 8-bit remainder to 16 bits
    end

endmodule