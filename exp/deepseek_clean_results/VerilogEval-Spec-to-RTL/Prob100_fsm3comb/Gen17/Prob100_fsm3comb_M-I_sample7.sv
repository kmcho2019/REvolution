module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Optimized output logic - only high when both state bits are high (state D)
assign out = state[1] & state[0];

// Optimized state transition logic using concatenated assignments
assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :  // A
                    (state == 2'b01) ? (in ? 2'b01 : 2'b10) :  // B
                    (state == 2'b10) ? (in ? 2'b11 : 2'b00) :  // C
                    (in ? 2'b01 : 2'b10);                     // D

endmodule