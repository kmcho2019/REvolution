module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(y or w) begin
    Y1 = y[0] & ~w; // State A
    Y2 = (y[1] & ~w) | (y[5] & w); // State B
    Y3 = (y[2] & ~w) | (y[1] & w) | (y[3] & w) | (y[4] & w); // State D
    Y4 = y[4] & ~w; // State E
end

endmodule