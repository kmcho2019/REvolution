module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// LUT for next_state transitions
always @(*) begin
    case ({state, in})
        3'b000: next_state = 2'b00; // A, in=0 → A
        3'b001: next_state = 2'b01; // A, in=1 → B
        3'b010: next_state = 2'b10; // B, in=0 → C
        3'b011: next_state = 2'b01; // B, in=1 → B
        3'b100: next_state = 2'b00; // C, in=0 → A
        3'b101: next_state = 2'b11; // C, in=1 → D
        3'b110: next_state = 2'b10; // D, in=0 → C
        3'b111: next_state = 2'b01; // D, in=1 → B
        default: next_state = 2'b00; // handle undefined cases
    endcase
end

// Output is simply when in state D (11)
assign out = state[1] & state[0];

endmodule