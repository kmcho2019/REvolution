module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Capture inputs into registers a_reg and b_reg
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic: iterative combinational division
    always @(*) begin
        integer i;
        reg [15:0] remainder;
        reg [15:0] quotient;
        reg [15:0] temp;

        quotient = 16'b0;
        remainder = 16'b0;

        // We process from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 bit and bring in the next dividend bit
            remainder = {remainder[14:0], a_reg[i]};

            // Compare upper bits of remainder with divisor
            // Extract upper 8 bits of remainder for comparison
            if (remainder[15:8] >= b_reg) begin
                // Subtract divisor from upper bits of remainder
                temp = {remainder[15:8] - b_reg, remainder[7:0]};
                remainder = temp;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder;
    end

endmodule