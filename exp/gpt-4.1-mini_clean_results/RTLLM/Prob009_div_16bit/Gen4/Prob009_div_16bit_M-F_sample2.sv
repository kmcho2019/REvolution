module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational block to latch inputs into internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational block performs division (restoring division)
    always @(*) begin
        integer i;
        reg [8:0] remainder;    // 9 bits: 8 bits divisor + 1 extra bit
        reg [15:0] quotient;
        reg [8:0] divisor_ext;

        remainder = 9'b0;
        quotient  = 16'b0;
        divisor_ext = {1'b0, b_reg}; // extend divisor to 9 bits for comparison

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit and bring down the next bit of dividend
            remainder = {remainder[7:0], a_reg[i]};

            // Compare full 9-bit remainder with divisor_ext
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Output remainder zero-extended to 16 bits from 8-bit remainder (lowest 8 bits of remainder)
        odd = {8'b0, remainder[7:0]};
    end

endmodule