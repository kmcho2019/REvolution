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

    // State A
    if (y[0] && ~w) Y1 = 1;
    // State D
    if (y[3] && w) Y1 = 1;

    // State F
    if (y[5] && ~w) Y2 = 1;

    // State B
    if (y[1] && ~w) Y3 = 1;

    // State C, E, F, B
    if ((y[2] && w) || (y[4] && w) || (y[5] && w) || (y[1] && w)) Y4 = 1;
end

endmodule