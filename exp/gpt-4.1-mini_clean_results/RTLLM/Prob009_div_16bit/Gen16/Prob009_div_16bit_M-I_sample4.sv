module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // First combinational always block: latch inputs combinationally into registers
    reg [15:0] a_reg;
    reg [7:0]  b_reg;
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: perform division
    // Variables for internal calculation
    reg [8:0] remainder; // 9 bits to hold remainder during calculation (8 bits divisor + 1)
    reg [15:0] quotient_tmp;
    integer i;

    always @(*) begin
        remainder = 9'd0;
        quotient_tmp = 16'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring in next highest bit from dividend
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end
        result = quotient_tmp;
        // zero-extend remainder to 16 bits as output 'odd'
        odd = {8'd0, remainder[7:0]};
    end

endmodule