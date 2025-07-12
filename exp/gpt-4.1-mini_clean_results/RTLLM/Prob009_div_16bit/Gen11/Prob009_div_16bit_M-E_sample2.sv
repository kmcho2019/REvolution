module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Capture inputs into registers (combinational style)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division combinational logic: shift-subtract approach
    always @(*) begin
        integer i;
        reg [15:0] quotient;
        reg [15:0] remainder; // will hold up to 16 bits during calculation
        reg [15:0] current;

        quotient = 16'd0;
        // Initialize remainder with the highest 8 bits of dividend
        remainder = {8'd0, a_reg[15:8]}; // zero-extend to 16 bits for subtraction

        // Perform 16 iterations: The division considers one dividend bit per iteration
        // The divisor is 8 bits, so remainder will be adjusted accordingly.
        for (i = 8; i < 16; i = i + 1) begin
            // Shift remainder left by 1 and bring in next dividend bit
            remainder = {remainder[14:0], a_reg[15 - i]};
            // Compare remainder[15:8] (upper bits) with divisor b_reg
            // Actually compare full remainder with divisor shifted appropriately:
            // but since divisor is 8 bits, compare remainder[15:8] vs b_reg,
            // then subtract if needed.
            // But to match the description, compare remainder[15:8] with divisor:

            if (remainder[15:8] >= b_reg) begin
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[15 - i] = 1'b1;
            end else begin
                quotient[15 - i] = 1'b0;
            end
        end

        // Now process lower 8 bits of dividend
        // The above only processed bits 15 down to 8; now process bits 7 down to 0
        // by similarly shifting remainder and subtracting divisor

        for (i = 0; i < 8; i = i + 1) begin
            remainder = {remainder[14:0], a_reg[7 - i]};
            if (remainder[15:8] >= b_reg) begin
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[7 - i] = 1'b1;
            end else begin
                quotient[7 - i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;  // full 16-bit remainder, upper 8 bits after all iterations
    end

endmodule