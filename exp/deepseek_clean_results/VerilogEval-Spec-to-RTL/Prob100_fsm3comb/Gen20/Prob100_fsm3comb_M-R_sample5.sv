module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Moore output - 1 only in state D (11)
assign out = (state == 2'b11);

// State transition logic using ternary operators
assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) : // A -> B if in=1, else stay A
                   (state == 2'b01) ? (in ? 2'b01 : 2'b10) : // B -> B if in=1, else C
                   (state == 2'b10) ? (in ? 2'b11 : 2'b00) : // C -> D if in=1, else A
                   (state == 2'b11) ? (in ? 2'b01 : 2'b10) : // D -> B if in=1, else C
                   2'b00; // Default (should never be used as all states are covered)

endmodule