module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;
reg [7:0] temp;

always @(*) begin
    quotient = 0;
    remainder = 0;
end

always @(*) begin
    for (int i = 15; i >= 0; i--) begin
        temp = remainder[7:0];
        remainder = {remainder[7:0], A[i]};
        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << i);
            remainder = remainder - {8'd0, B};
        end
    end
end

assign result = quotient;
assign odd = {8'd0, remainder[7:0]};

endmodule