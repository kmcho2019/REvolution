module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
always @(*) begin
    case(state)
        4'b0001: // State A
            if (!in) next_state = 4'b0001; // Next state is A
            else    next_state = 4'b0010; // Next state is B
        4'b0010: // State B
            if (!in) next_state = 4'b0100; // Next state is C
            else    next_state = 4'b0010; // Next state is B
        4'b0100: // State C
            if (!in) next_state = 4'b0001; // Next state is A
            else    next_state = 4'b1000; // Next state is D
        4'b1000: // State D
            if (!in) next_state = 4'b0100; // Next state is C
            else    next_state = 4'b0010; // Next state is B
        default:
            next_state = 4'b0000; // Unknown state, reset to 0
    endcase
end

// Output logic
assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

endmodule