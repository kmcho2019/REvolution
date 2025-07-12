module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

reg [15:0] remainder;
reg [15:0] quotient;

assign result = quotient;
assign odd = {8'd0, remainder[7:0]};

always @(*) begin
    remainder = A;
    quotient = 0;
    for (int i = 0; i < 16; i++) begin
        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << (15-i));
            remainder = remainder - {8'd0, B};
        end
        if (i < 15) begin
            remainder = {remainder[7:0], A[15-(i+1)]};
        end
    end
end

endmodule