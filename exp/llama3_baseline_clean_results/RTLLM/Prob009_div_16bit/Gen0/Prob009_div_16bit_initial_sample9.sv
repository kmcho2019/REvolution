module div_16bit(
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

reg [15:0] a_reg;
reg [7:0]  b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    reg [15:0] dividend;
    reg [7:0]  divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [3:0]  count;

    dividend = a_reg;
    divisor  = b_reg;
    quotient = 0;
    remainder = 0;
    count    = 8;

    while (count > 0) begin
        if (dividend[15:8] >= divisor) begin
            quotient = quotient + (1 << (count - 1));
            remainder = dividend[15:8] - divisor;
        end else begin
            remainder = dividend[15:8];
        end

        dividend = {remainder, dividend[7:0]};
        count = count - 1;
    end

    result = quotient;
    odd    = {8'd0, remainder};
end

endmodule