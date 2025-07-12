module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Moore output - depends only on current state
assign out = (state == 2'b11); // Output 1 when in state D (2'b11)

// State transition logic using nested ternary operators
assign next_state = 
    (state == 2'b00) ? (in ? 2'b01 : 2'b00) : // State A: A->B if in=1, else stay A
    (state == 2'b01) ? (in ? 2'b01 : 2'b10) : // State B: B->B if in=1, else C
    (state == 2'b10) ? (in ? 2'b11 : 2'b00) : // State C: C->D if in=1, else A
                      (in ? 2'b01 : 2'b10);   // State D: D->B if in=1, else C

endmodule