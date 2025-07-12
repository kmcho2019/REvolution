module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

// Output logic remains the same as it's straightforward and efficient
assign out = (state == 2'b11) ? 1'b1 : 1'b0;

// Next state logic: Trying an alternative approach using an always block
// to see if synthesis tools can optimize it better than the ternary operators
always @(*) begin
    case(state)
        2'b00: next_state = in ? 2'b01 : 2'b00;
        2'b01: next_state = in ? 2'b01 : 2'b10;
        2'b10: next_state = in ? 2'b11 : 2'b00;
        2'b11: next_state = in ? 2'b01 : 2'b10;
        default: next_state = 2'b00; // Default to state A if state is unknown
    endcase
end

endmodule