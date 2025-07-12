module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First always block: combinational "registering" of inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    integer i;
    reg [8:0] remainder;   // 9-bit remainder to handle subtraction + MSB
    reg [15:0] quotient;

    always @(*) begin
        remainder = 9'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i -1) begin
            remainder = {remainder[7:0], a_reg[i]}; // Shift left remainder and bring in next dividend bit

            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]};  // zero-extend remainder to 16 bits
    end

endmodule