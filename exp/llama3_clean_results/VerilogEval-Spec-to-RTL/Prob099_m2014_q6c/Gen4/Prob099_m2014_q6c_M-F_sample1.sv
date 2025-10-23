module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

reg [5:0] nextState;

always @(*)
begin
    case (1'b1)
        y[0]: // State A
            nextState = (w) ? 6'b100000 : 6'b010000; // If w is 1, stay in A, otherwise go to B
        y[1]: // State B
            nextState = (w) ? 6'b001000 : 6'b000100; // If w is 1, go to D, otherwise go to C
        y[2]: // State C
            nextState = (w) ? 6'b001000 : 6'b000010; // If w is 1, go to D, otherwise go to E
        y[3]: // State D
            nextState = (w) ? 6'b100000 : 6'b010000; // If w is 1, go to A, otherwise go to F
        y[4]: // State E
            nextState = (w) ? 6'b001000 : 6'b100000; // If w is 1, go to D, otherwise stay in E
        y[5]: // State F
            nextState = (w) ? 6'b001000 : 6'b000100; // If w is 1, go to D, otherwise go to C
        default:
            nextState = 6'b100000; // Reset to state A
    endcase

    // Determine Y1, Y2, Y3, and Y4 based on the next state
    Y1 = nextState[0]; // Y1 corresponds to state A
    Y2 = nextState[1]; // Y2 corresponds to state B
    Y3 = nextState[3]; // Y3 corresponds to state D
    Y4 = nextState[4]; // Y4 corresponds to state E
end

endmodule