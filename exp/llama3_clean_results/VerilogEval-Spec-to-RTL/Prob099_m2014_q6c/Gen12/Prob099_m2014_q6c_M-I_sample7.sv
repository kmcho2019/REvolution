module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*) begin
    Y1 = (y[0] && ~w) || (y[3] && w);
    Y2 = (y[0] && w) || (y[5] && ~w);
    Y3 = y[1] && ~w;
    Y4 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);
end

endmodule