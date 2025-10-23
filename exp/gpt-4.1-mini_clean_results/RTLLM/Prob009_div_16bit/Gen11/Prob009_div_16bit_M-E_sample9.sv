module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // Internal registers to hold latched inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into internal registers (combinational latch style)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic
    always @(*) begin
        integer i;
        reg [15:0] quotient;
        reg [8:0] remainder;        // 9-bit remainder (one bit wider than divisor)
        reg [8:0] divisor_ext;      // zero-extended divisor

        quotient = 16'b0;
        remainder = 9'b0;
        divisor_ext = {1'b0, b_reg};

        // Initialize remainder with the top 8 bits of the dividend
        remainder = {1'b0, a_reg[15:8]};

        // Process bits from bit 7 down to 0 of the dividend
        for (i = 7; i >= 0; i = i -1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            remainder = {remainder[7:0], a_reg[i]};

            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i + 8] = 1'b1; // Quotient bit matches dividend bit position
            end else begin
                quotient[i + 8] = 1'b0;
            end
        end

        // Now handle the lower 8 bits of quotient (bits 7 downto 0)
        // Initialize remainder with zero (since those bits correspond to no further dividend bits to bring down)
        // We'll now simulate similar steps with zero bits appended
        for (i = 7; i >= 0; i = i -1) begin
            // Shift remainder left by 1 and bring down 0 as next bit (no more dividend bits)
            remainder = {remainder[7:0], 1'b0};

            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder[7:0]}; // lower 8 bits of remainder valid, upper 8 zero
    end

endmodule