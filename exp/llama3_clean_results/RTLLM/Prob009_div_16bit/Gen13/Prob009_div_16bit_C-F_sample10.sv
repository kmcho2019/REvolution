module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] quotient;
reg [15:0] remainder;

always @(*) begin
    quotient = 0;
    remainder = 0;

    // Loop unrolling and pipelining
    for (int i = 15; i >= 8; i -= 2) begin
        remainder = {remainder[7:0], A[i+:2]};
        if (remainder >= {8'd0, B}) begin
            quotient = quotient | (1 << (i / 2));
            remainder = remainder - {8'd0, B};
        end
    end

    // Final iteration
    remainder = {remainder[7:0], A[7:0]};
    if (remainder >= {8'd0, B}) begin
        quotient = quotient | (1 << 0);
        remainder = remainder - {8'd0, B};
    end

    result = quotient;
    odd = {8'd0, remainder[7:0]};
end

endmodule