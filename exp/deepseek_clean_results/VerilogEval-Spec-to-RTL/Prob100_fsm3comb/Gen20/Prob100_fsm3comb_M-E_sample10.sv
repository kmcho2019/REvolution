module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// LUT containing all transition rules [current_state][input] -> next_state
parameter [7:0] TRANSITION_LUT = {
    2'b10, // D (11) + in=1 -> B (01)
    2'b10, // D (11) + in=0 -> C (10)
    2'b11, // C (10) + in=1 -> D (11)
    2'b00, // C (10) + in=0 -> A (00)
    2'b01, // B (01) + in=1 -> B (01)
    2'b10, // B (01) + in=0 -> C (10)
    2'b01, // A (00) + in=1 -> B (01)
    2'b00  // A (00) + in=0 -> A (00)
};

// Index into LUT using {state, in} concatenation
wire [2:0] lut_index = {state, in};
assign next_state = TRANSITION_LUT[lut_index*2 +: 2];

// Moore output - 1 only in state D
assign out = (state == 2'b11);

endmodule