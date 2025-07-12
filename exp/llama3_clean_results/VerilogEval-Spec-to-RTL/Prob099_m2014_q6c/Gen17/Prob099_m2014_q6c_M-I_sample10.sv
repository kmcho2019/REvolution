module TopModule(
    input [5:0] y, // One-hot encoded state
    input w,
    output Y1, // Corresponds to y[1] (state B)
    output Y3  // Corresponds to y[3] (state D)
);

always @(*) begin
    // Next-state logic for Y1 (y[1]) which corresponds to state B
    Y1 = (y[0] && ~w) || (y[5] && ~w); // From A or F to B when w is 0
    
    // Next-state logic for Y3 (y[3]) which corresponds to state D
    Y3 = (y[1] && w) || (y[2] && w) || (y[4] && ~w) || (y[5] && w); // From B or C or E (when w=0) or F to D
end

endmodule