module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State transition logic
assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :  // State A
                    (state == 2'b01) ? (in ? 2'b01 : 2'b10) :  // State B
                    (state == 2'b10) ? (in ? 2'b11 : 2'b00) :  // State C
                                       (in ? 2'b01 : 2'b10);   // State D

// Output is high only when in state D (11)
assign out = state[1] & state[0];

endmodule