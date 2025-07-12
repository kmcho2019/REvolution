module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Define the states for the top level
wire [5:0] nextState;

// Top level state machine logic
always_comb begin
    case ({y[5], y[4], y[3], y[2], y[1], y[0]})
        6'b000001: // State A
            if (!w)
                nextState = 6'b000010; // Transition to B
            else
                nextState = 6'b000001; // Stay in A
        6'b000010: // State B
            if (!w)
                nextState = 6'b000100; // Transition to C
            else
                nextState = 6'b001000; // Transition to D
        6'b000100: // State C
            if (!w)
                nextState = 6'b010000; // Transition to E
            else
                nextState = 6'b001000; // Transition to D
        6'b001000: // State D
            if (!w)
                nextState = 6'b100000; // Transition to F
            else
                nextState = 6'b000001; // Transition to A
        6'b010000: // State E
            if (w)
                nextState = 6'b010000; // Stay in E
            else
                nextState = 6'b010000; // Stay in E
        6'b100000: // State F
            if (w)
                nextState = 6'b000100; // Transition to C
            else
                nextState = 6'b000100; // Transition to C
        default: // Unknown state, stay in A
            nextState = 6'b000001;
    endcase
end

// Lower level logic to generate Y1 and Y3
assign Y1 = nextState[0]; // Y1 is the least significant bit of the next state
assign Y3 = nextState[3]; // Y3 is the 4th bit of the next state

endmodule