module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    Y1 = 0;
    Y3 = 0;

    if (y[0] && ~w) Y1 = 1; // A to B
    if (y[1] && w) Y3 = 1; // B to D
    if (y[2] && w) Y3 = 1; // C to D
    if (y[3] && ~w) Y1 = 1; // D to A
    if (y[3] && w) Y1 = 1; // D to A
    if (y[5] && ~w) Y1 = 1; // F to C (and then to B), B to A
end

endmodule