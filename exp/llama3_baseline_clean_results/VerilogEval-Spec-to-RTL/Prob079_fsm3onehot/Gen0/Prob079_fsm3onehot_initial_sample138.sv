module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
always @(state, in) begin
    case (state)
        4'b0001: // State A
            if (!in) 
                next_state = 4'b0001; // Next state is A when in=0
            else 
                next_state = 4'b0010; // Next state is B when in=1
        4'b0010: // State B
            if (!in) 
                next_state = 4'b0100; // Next state is C when in=0
            else 
                next_state = 4'b0010; // Next state is B when in=1
        4'b0100: // State C
            if (!in) 
                next_state = 4'b0001; // Next state is A when in=0
            else 
                next_state = 4'b1000; // Next state is D when in=1
        4'b1000: // State D
            if (!in) 
                next_state = 4'b0100; // Next state is C when in=0
            else 
                next_state = 4'b0010; // Next state is B when in=1
        default: // Invalid state
            next_state = 4'b0000; // Next state is unknown
    endcase
end

// Output logic
always @(state) begin
    case (state)
        4'b0001, 4'b0010, 4'b0100: // States A, B, C
            out = 1'b0; // Output is 0
        4'b1000: // State D
            out = 1'b1; // Output is 1
        default: // Invalid state
            out = 1'b0; // Output is 0
    endcase
end

endmodule