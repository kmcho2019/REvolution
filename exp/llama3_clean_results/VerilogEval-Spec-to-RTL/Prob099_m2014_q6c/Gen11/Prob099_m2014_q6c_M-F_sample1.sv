module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    Y1 = 0;
    Y3 = 0;

    // State A transitions to B when w is 0
    if (y[0] && ~w) Y1 = 1; // Transition to state B
    
    // State A stays in A when w is 1, no action needed for Y1 or Y3

    // State B transitions to C when w is 0, and to D when w is 1
    if (y[1] && w) Y3 = 1; // Transition to state D

    // State C transitions to E when w is 0, and to D when w is 1
    if (y[2] && w) Y3 = 1; // Transition to state D

    // State D transitions to F when w is 0, and to A when w is 1
    // No direct transition to B or D from D affects Y1 or Y3

    // State E stays in E when w is 0, and transitions to D when w is 1
    if (y[4] && w) Y3 = 1; // Transition to state D

    // State F transitions to C when w is 0, and to D when w is 1
    if (y[5] && w) Y3 = 1; // Transition to state D
end

endmodule