module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [15:0] quotient;
wire [15:0] remainder;

assign result = quotient;
assign odd = {8'd0, remainder[7:0]};

always @(*) begin
    quotient = 0;
    remainder = 0;

    for (int i = 15; i >= 0; i--) begin
        remainder = {remainder[7:0], A[i]};
        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << i);
            remainder = remainder - {8'd0, B};
        end
    end
end

endmodule