module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers (combinationally)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic on latched inputs
    always @(*) begin
        integer i;
        reg [8:0] remainder;
        reg [15:0] quotient;
        reg [8:0] divisor_ext;

        remainder = 9'b0;
        quotient  = 16'b0;
        divisor_ext = {1'b0, b_reg}; // extend divisor to 9 bits for comparison

        // Perform bit-by-bit division (restoring division method)
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
        // zero-extend remainder to 16 bits at output; remainder is 9 bits but only lower 8 bits valid remainder
        odd = {8'b0, remainder[7:0]};
    end

endmodule