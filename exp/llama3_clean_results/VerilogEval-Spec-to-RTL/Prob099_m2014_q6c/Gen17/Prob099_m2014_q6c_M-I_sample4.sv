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
    Y3 = (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[3] && w);
    
    // Next-state signal Y4 (state D, considering only relevant transitions)
    Y4 = Y3; // Since Y4 corresponds to the same state as Y3, we can directly assign Y3 to Y4
    
end

endmodule