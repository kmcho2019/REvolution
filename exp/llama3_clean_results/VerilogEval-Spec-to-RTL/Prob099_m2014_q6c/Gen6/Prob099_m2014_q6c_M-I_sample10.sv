module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(y or w) begin
    // State A (y[0]) or State D (y[3]) with w = 0
    Y1 = (y[0] & ~w) | (y[3] & ~w);

    // State B (y[1]) with w = 1, State C (y[2]) with w = 0, or State F (y[5]) with w = 0
    Y3 = (y[1] & w) | (y[2] & ~w) | (y[5] & ~w);
end

endmodule