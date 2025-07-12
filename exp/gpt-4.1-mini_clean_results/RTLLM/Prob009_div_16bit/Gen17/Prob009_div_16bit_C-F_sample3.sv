module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;           // Registered dividend (combinational latch)
    reg [7:0]  b_reg;           // Registered divisor (combinational latch)

    // Latch inputs into internal registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic: shift-subtract algorithm
    // Using 9-bit remainder to accommodate divisor comparison
    reg [8:0] remainder;
    integer i;
    reg [15:0] quotient;

    always @(*) begin
        remainder = 9'd0;
        quotient = 16'd0;

        // Process each dividend bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Compare remainder with divisor
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end
            else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]}; // zero-extend remainder to 16 bits
    end

endmodule