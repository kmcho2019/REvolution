module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    // First always block: combinational input register stage
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division logic
    always @(*) begin
        integer i;
        reg [7:0] remainder;      // 8-bit remainder
        reg [15:0] quotient;

        remainder = 8'd0;
        quotient = 16'd0;

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[6:0], a_reg[i]};
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder};
    end

endmodule