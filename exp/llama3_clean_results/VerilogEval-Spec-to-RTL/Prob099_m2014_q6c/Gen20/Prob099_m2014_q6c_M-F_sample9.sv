module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3,
    output Y2,
    output Y4
);

reg [5:0] nextState;

always_comb begin
    case (1)
        y[0]: // State A
            if (!w)
                nextState = 6'b000010; // Transition to B
            else
                nextState = 6'b000001; // Stay in A
        y[1]: // State B
            if (!w)
                nextState = 6'b000100; // Transition to C
            else
                nextState = 6'b001000; // Transition to D
        y[2]: // State C
            if (!w)
                nextState = 6'b010000; // Transition to E
            else
                nextState = 6'b001000; // Transition to D
        y[3]: // State D
            if (!w)
                nextState = 6'b100000; // Transition to F
            else
                nextState = 6'b000001; // Transition to A
        y[4]: // State E
            if (w)
                nextState = 6'b010000; // Stay in E
            else
                nextState = 6'b010000; // This case is not valid based on the given state machine, adjust accordingly
        y[5]: // State F
            if (w)
                nextState = 6'b000100; // Transition to C
            else
                nextState = 6'b000100; // Transition to C
        default: // Unknown state, stay in A
            nextState = 6'b000001;
    endcase
end

assign Y1 = nextState[0]; // Y1 is the least significant bit of the next state
assign Y2 = nextState[1]; // Y2 is the 2nd bit of the next state
assign Y3 = nextState[2]; // Y3 is the 3rd bit of the next state
assign Y4 = nextState[3]; // Y4 is the 4th bit of the next state

endmodule