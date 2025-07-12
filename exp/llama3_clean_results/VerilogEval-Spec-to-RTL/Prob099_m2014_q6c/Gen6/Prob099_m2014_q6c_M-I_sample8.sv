module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(y or w) begin
    // State A (Y1)
    Y1 = (y[0] & ~w) | (y[3] & ~w);

    // State C (Y3)
    Y3 = (y[1] & w) | (y[2] & ~w) | (y[5] & ~w);
end

endmodule