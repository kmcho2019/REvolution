module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    Y1 = (y[0] & ~w) | (y[3] & ~w) | (y[5] & ~w); // A to B, D to A, F to C (and then to B)
    Y3 = (y[1] & w) | (y[2] & w) | (y[3] & w) | (y[4] & w); // B to D, C to D, D to A, E to D
end

endmodule