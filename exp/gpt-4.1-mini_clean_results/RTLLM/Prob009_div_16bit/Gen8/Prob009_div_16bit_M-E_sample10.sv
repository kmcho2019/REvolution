module div_16bit (
    input  wire [15:0] A,         // 16-bit dividend
    input  wire [7:0]  B,         // 8-bit divisor
    output reg  [15:0] result,    // 16-bit quotient
    output reg  [15:0] odd        // 16-bit remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs to internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic: non-restoring style with shifted remainder
    always @(*) begin
        integer i;
        reg [15:0] quotient;
        reg [7:0] remainder;
        reg [8:0] rem_shifted; // 9-bit to hold remainder shifted left + next dividend bit
        reg [7:0] divisor;

        quotient = 16'd0;
        remainder = 8'd0;
        divisor = b_reg;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in next dividend bit
            rem_shifted = {remainder, a_reg[i]};

            if (rem_shifted[8:1] >= divisor) begin
                rem_shifted = rem_shifted - {1'b0, divisor};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
            remainder = rem_shifted[7:0];
        end

        result = quotient;
        odd = {8'd0, remainder};
    end

endmodule