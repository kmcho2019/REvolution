module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    Y1 = 0;
    Y3 = 0;

    // State A
    if (y[0] && ~w) Y1 = 1;
    // State D
    if (y[3] && w) Y1 = 1;

    // State B
    if (y[1] && ~w) Y3 = 1;
end

endmodule