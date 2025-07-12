module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
always @(*) begin
    case(state)
        4'b0001: next_state = (in == 0)? 4'b0001 : 4'b0010; // A to A (in=0) or B (in=1)
        4'b0010: next_state = (in == 0)? 4'b0100 : 4'b0010; // B to C (in=0) or B (in=1)
        4'b0100: next_state = (in == 0)? 4'b0001 : 4'b1000; // C to A (in=0) or D (in=1)
        4'b1000: next_state = (in == 0)? 4'b0100 : 4'b0010; // D to C (in=0) or B (in=1)
        default: next_state = 4'b0000; // Invalid state, default to 0
    endcase
end

// Output logic
always @(*) begin
    case(state)
        4'b1000: out = 1'b1; // Output is 1 when in state D
        default: out = 1'b0; // Output is 0 for all other states
    endcase
end

endmodule