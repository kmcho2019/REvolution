module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0] b_reg;
    integer i;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        reg [16:0] dividend = {1'b0, a_reg};
        reg [8:0] divisor = {1'b0, b_reg};
        reg [16:0] remainder = 0;
        reg [15:0] quotient = 0;

        for (i = 0; i < 16; i = i + 1) begin
            // Shift remainder and quotient left
            remainder = remainder << 1;
            // Bring down next bit of dividend
            remainder[0] = dividend[15 - i];
            
            // Compare remainder with divisor
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[15 - i] = 1'b1;
            end else begin
                quotient[15 - i] = 1'b0;
            end
        end

        result = quotient;
        odd = remainder[15:0];
    end

endmodule