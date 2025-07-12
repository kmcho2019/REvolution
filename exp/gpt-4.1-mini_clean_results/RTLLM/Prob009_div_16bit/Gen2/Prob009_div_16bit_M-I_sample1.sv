module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers combinationally
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational division
    always @(*) begin
        reg [15:0] quotient;
        reg [7:0]  remainder;
        integer i;

        quotient = 16'd0;
        remainder = 8'd0;

        // Iterate from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1, bring in next dividend bit
            remainder = {remainder[6:0], a_reg[i]};

            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Zero-extend remainder to 16 bits for output
        odd = {8'd0, remainder};
    end

endmodule