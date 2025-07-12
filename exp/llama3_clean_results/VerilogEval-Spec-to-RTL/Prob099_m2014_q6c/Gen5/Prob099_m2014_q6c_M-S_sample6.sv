module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

reg Y1, Y3;

always @(y or w) begin
    // Next-state logic for Y1 (state A or state D)
    Y1 = (y[0] & ~w) | (y[3] & ~w);
    
    // Next-state logic for Y3 (state B or state E)
    Y3 = (y[1] & w) | (y[4] & w);
end

endmodule