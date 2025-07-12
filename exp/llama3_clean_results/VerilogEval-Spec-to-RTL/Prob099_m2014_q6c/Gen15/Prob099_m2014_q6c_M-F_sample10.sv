module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

always @(*)
begin
    // Next-state signal Y1 (state B)
    Y1 = (y[0] && w) || (y[4] && ~w);
    
    // Next-state signal Y2 (state C)
    Y2 = (y[1] && ~w) || (y[5] && ~w);
    
    // Next-state signal Y3 (state D)
    Y3 = (y[1] && w) || (y[2] && w) || (y[3] && w) || (y[4] && w);
    
    // Next-state signal Y4 (state E)
    Y4 = (y[2] && w);
    
end

endmodule