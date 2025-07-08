module div_16bit (
    input  [15:0] A,
    input  [7:0]  B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    integer i;
    reg [15:0] quotient;
    reg [15:0] remainder;

    always @(*) begin
        quotient = 16'd0;
        remainder = 16'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 and bring down next bit from dividend
            remainder = {remainder[14:0], a_reg[i]};
            if (remainder[7:0] >= b_reg) begin
                remainder[7:0] = remainder[7:0] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end
        result = quotient;
        odd = remainder;
    end

endmodule