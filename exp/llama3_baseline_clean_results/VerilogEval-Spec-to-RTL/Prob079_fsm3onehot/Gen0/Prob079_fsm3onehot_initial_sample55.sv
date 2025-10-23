module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Combinational logic for next state
always @(*) begin
    case (state)
        4'b0001: next_state = (in == 1'b0) ? 4'b0001 : 4'b0010; // A
        4'b0010: next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // B
        4'b0100: next_state = (in == 1'b0) ? 4'b0001 : 4'b1000; // C
        4'b1000: next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // D
        default: next_state = 4'b0000; // Invalid state, set to unknown
    endcase
end

// Combinational logic for output
assign out = (state == 4'b1000) ? 1'b1 : 1'b0; // Output is 1 only in state D

endmodule