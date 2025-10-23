module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division algorithm combinational block
    // Implements the described division by shifting and subtracting divisor
    always @(*) begin
        integer i;
        reg [8:0] remainder;  // 9-bit remainder register: 8-bit divisor + 1 bit carry
        reg [15:0] quotient_tmp;

        remainder = 9'd0;
        quotient_tmp = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};

            // Compare and subtract divisor if possible
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        odd = {8'd0, remainder[7:0]}; // remainder lower 8 bits valid, upper 8 bits zero
    end

endmodule