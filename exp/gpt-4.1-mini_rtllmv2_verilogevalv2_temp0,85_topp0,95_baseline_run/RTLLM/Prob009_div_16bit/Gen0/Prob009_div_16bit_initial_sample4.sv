module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs into registers (combinational)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic
    // Using restoring division algorithm over 16 steps
    integer i;
    reg [15:0] quotient;
    reg [7:0] remainder; // remainder width matches divisor width

    always @(*) begin
        quotient  = 16'b0;
        remainder = 8'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            remainder = {remainder[6:0], a_reg[i]};
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd    = {8'b0, remainder}; // Pad remainder to 16 bits as output
    end

endmodule