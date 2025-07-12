module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic: out is 1 only when the state is D (4'b1000)
assign out = state[3]; // state[3] corresponds to state D

// Next state logic
always @(*) begin
    case(state)
        4'b0001: // State A
            if(!in) next_state = 4'b0001; // Next state is A if in=0
            else next_state = 4'b0010; // Next state is B if in=1
        4'b0010: // State B
            if(!in) next_state = 4'b0100; // Next state is C if in=0
            else next_state = 4'b0010; // Next state is B if in=1
        4'b0100: // State C
            if(!in) next_state = 4'b0001; // Next state is A if in=0
            else next_state = 4'b1000; // Next state is D if in=1
        4'b1000: // State D
            if(!in) next_state = 4'b0100; // Next state is C if in=0
            else next_state = 4'b0010; // Next state is B if in=1
        default: next_state = 4'b0000; // Default next state if current state is not recognized
    endcase
end

endmodule