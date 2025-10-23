module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Simplified state transition logic
assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :  // State A
                    (state == 2'b01) ? (in ? 2'b01 : 2'b10) :  // State B
                    (state == 2'b10) ? (in ? 2'b11 : 2'b00) :  // State C
                                       (in ? 2'b01 : 2'b10);   // State D

// Simplified output logic - only high when both state bits are 1 (state D)
assign out = &state;

endmodule