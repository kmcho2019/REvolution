module div_logic(
    input [15:0] dividend,
    input [7:0] divisor,
    output reg [15:0] quotient,
    output reg [7:0] remainder
);

always @(*) begin
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        remainder = {remainder[7:0], dividend[i]};
        if (remainder >= {8'd0, divisor}) begin
            quotient = quotient | (1 << i);
            remainder = remainder - {8'd0, divisor};
        end
    end
end

endmodule

module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [7:0] remainder;

div_logic div_module(
    .dividend(A),
    .divisor(B),
    .quotient(quotient),
    .remainder(remainder)
);

assign result = quotient;
assign odd = {8'd0, remainder};

endmodule