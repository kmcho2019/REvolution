module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic: based on the current state
assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

// Next state logic
always @(state, in)
begin
    case(state)
        4'b0001: next_state = (in == 1'b0) ? 4'b0001 : 4'b0010; // A
        4'b0010: next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // B
        4'b0100: next_state = (in == 1'b0) ? 4'b0001 : 4'b1000; // C
        4'b1000: next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // D
        default: next_state = 4'b0001; // Default to state A if none match
    endcase
end

endmodule