module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
assign out = state[3]; // D state has out = 1

// State transition logic
always @(*) begin
    case (state)
        4'b0001: // State A
            next_state = in ? 4'b0010 : 4'b0001; // Next state is B if in=1, A if in=0
        4'b0010: // State B
            next_state = in ? 4'b0010 : 4'b0100; // Next state is B if in=1, C if in=0
        4'b0100: // State C
            next_state = in ? 4'b1000 : 4'b0001; // Next state is D if in=1, A if in=0
        4'b1000: // State D
            next_state = in ? 4'b0010 : 4'b0100; // Next state is B if in=1, C if in=0
        default: // Invalid state
            next_state = 4'b0000; // or some other appropriate action
    endcase
end

endmodule