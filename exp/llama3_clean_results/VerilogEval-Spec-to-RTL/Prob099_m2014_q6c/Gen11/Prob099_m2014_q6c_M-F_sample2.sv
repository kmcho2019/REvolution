module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    Y1 = 0;
    Y2 = 0;
    Y3 = 0;
    Y4 = 0;

    // Y1 (state B)
    Y1 = (y[0] & ~w) | (y[1] & w);

    // Y2 (state C)
    Y2 = (y[1] & ~w) | (y[2] & w);

    // Y3 (state D)
    Y3 = (y[1] & w) | (y[2] & w) | (y[3] & ~w) | (y[4] & w);

    // Y4 (state E)
    Y4 = (y[2] & w) | (y[4] & w);
end

endmodule