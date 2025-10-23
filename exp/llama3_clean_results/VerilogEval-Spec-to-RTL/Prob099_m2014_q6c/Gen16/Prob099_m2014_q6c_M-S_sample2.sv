module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

always @(*) begin
    Y1 = ~w && (y[0] || y[5]); // State A or F and w is 0
    Y3 = ~w && (y[1] || y[2] || y[4] || y[5]); // States B, C, E, or F and w is 0
end

endmodule