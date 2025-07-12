module TopModule (
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    // Y1 is only set when in state A (y[0]) and w is 1
    Y1 = y[0] & w;

    // Y3 is set when:
    // 1. Not in state A (y[0]) or D (y[3])
    // 2. And w is 0
    // Using one-hot property, this simplifies to checking y[0] and y[3]
    Y3 = ~w & ~(y[0] | y[3]);
end

endmodule