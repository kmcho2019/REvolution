module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Output depends only on current state (Moore machine)
assign out = (state == 2'b11); // 1 when in state D

// Next state logic using case for clarity
assign next_state = 
    (state == 2'b00) ? (in ? 2'b01 : 2'b00) : // State A
    (state == 2'b01) ? (in ? 2'b01 : 2'b10) : // State B
    (state == 2'b10) ? (in ? 2'b11 : 2'b00) : // State C
                       (in ? 2'b01 : 2'b10);  // State D

endmodule