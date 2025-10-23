module div_16bit(
    input  [15:0] A,
    input  [7:0]  B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [15:0] dividend;

always @(*) begin
    quotient = 0;
    remainder = 0;
    dividend = A;
    for (int i = 15; i >= 0; i--) begin
        if (dividend[15:8] >= B) begin
            quotient[i] = 1;
            remainder = (dividend[15:8] - B) << 8 | dividend[7:0];
        end else begin
            remainder = dividend;
        end
        dividend = {remainder[7:0], 8'd0};
    end
end

assign result = quotient;
assign odd = remainder;

endmodule