module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

reg Y2, Y4;

always @(*) begin
    Y1 = 0;
    Y2 = 0;
    Y3 = 0;
    Y4 = 0;

    // State A
    if (y[0]) begin
        if (~w) Y2 = 1; // Transition to state B
    end

    // State B
    if (y[1]) begin
        if (~w) Y3 = 1; // Transition to state C
        if (w) Y4 = 1; // Transition to state D
    end

    // State C
    if (y[2]) begin
        if (~w) Y4 = 1; // Transition to state E
        if (w) Y4 = 1; // Transition to state D
    end

    // State D
    if (y[3]) begin
        if (~w) Y4 = 0; // Transition to state F
        if (w) Y1 = 1; // Transition to state A
    end

    // State E
    if (y[4]) begin
        if (~w) Y4 = 1; // Stay in state E
        if (w) Y4 = 1; // Transition to state D
    end

    // State F
    if (y[5]) begin
        if (~w) Y2 = 1; // Transition to state C
        if (w) Y4 = 1; // Transition to state D
    end
end

endmodule