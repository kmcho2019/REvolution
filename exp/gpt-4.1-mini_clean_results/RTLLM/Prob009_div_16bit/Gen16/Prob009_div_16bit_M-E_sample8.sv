module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Input latch (combinational to satisfy problem statement)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    always @(*) begin
        integer i;
        reg [8:0] remainder;    // 9-bit remainder to hold up to divisor + 1 bit carry
        reg [15:0] quotient;    // 16-bit quotient accumulator

        remainder = 9'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i -1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Store remainder in odd, upper 8 bits zero-padded
        odd = {8'd0, remainder[7:0]};
    end

endmodule