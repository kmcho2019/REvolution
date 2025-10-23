module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational division
    always @(*) begin
        reg [8:0] remainder;     // 9-bit remainder to hold divisor plus borrow
        reg [15:0] quotient;
        integer i;

        remainder = 9'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i -1) begin
            // Shift remainder left by 1, input next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Compare and subtract
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]}; // zero-extend remainder to 16 bits
    end

endmodule