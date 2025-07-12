module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    result = 0;
    odd = 0;

    reg [15:0] remainder;
    remainder = {8'd0, A[15:8]};

    for (int i = 7; i >= 0; i--) begin
        remainder = {remainder[7:0], A[i]};
        if (remainder >= {8'd0, B}) begin
            result = result | (1 << i);
            remainder = remainder - {8'd0, B};
        end
    end

    odd = {8'd0, remainder[7:0]};
end

endmodule