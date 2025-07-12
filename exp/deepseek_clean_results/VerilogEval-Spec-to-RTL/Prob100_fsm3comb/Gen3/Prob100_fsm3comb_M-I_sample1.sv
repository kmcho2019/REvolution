module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Output is 1 only when in state D (11)
assign out = &state;  // Equivalent to state[1] & state[0]

always @(*) begin
    case (state)
        2'b00: next_state = {1'b0, in};          // A -> A(00) or B(01)
        2'b01: next_state = in ? 2'b01 : 2'b10;   // B -> B(01) or C(10)
        2'b10: next_state = {~in, in};            // C -> A(00) or D(11)
        2'b11: next_state = {~in, 1'b1};          // D -> C(10) or B(01)
    endcase
end

endmodule