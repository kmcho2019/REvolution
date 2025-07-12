module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

reg [5:0] nextState;

always @(*)
begin
    case (1'b1)
        y[0]: // State A
            nextState = (w) ? y : {5'b0, 1'b1}; // If w is 1, stay in A, otherwise go to B
        y[1]: // State B
            nextState = (w) ? {5'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0} : {4'b0, 1'b1, 1'b0, 1'b0, 1'b0}; // If w is 1, go to D, otherwise go to C
        y[2]: // State C
            nextState = (w) ? {5'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0} : {3'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0}; // If w is 1, go to D, otherwise go to E
        y[3]: // State D
            nextState = (w) ? {5'b0, 1'b1} : {5'b0, 1'b0, 1'b0, 1'b1}; // If w is 1, go to A, otherwise go to F
        y[4]: // State E
            nextState = (w) ? {5'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0} : {5'b0, 1'b0, 1'b0, 1'b0, 1'b0}; // If w is 1, go to D, otherwise stay in E
        y[5]: // State F
            nextState = (w) ? {5'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0} : {2'b0, 1'b1, 1'b0, 1'b0, 1'b0}; // If w is 1, go to D, otherwise go to C
        default:
            nextState = 6'b0;
    endcase

    // Determine Y1 and Y3 based on the next state
    Y1 = nextState[1]; // Y1 corresponds to state B
    Y3 = nextState[3]; // Y3 corresponds to state D
end

endmodule