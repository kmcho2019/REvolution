module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

assign out = (state == 2'b11); // Output is 1 only in state D

assign next_state = 
    (state == 2'b00) ? (in ? 2'b01 : 2'b00) : // State A
    (state == 2'b01) ? (in ? 2'b01 : 2'b10) : // State B
    (state == 2'b10) ? (in ? 2'b11 : 2'b00) : // State C
    (state == 2'b11) ? (in ? 2'b01 : 2'b10) : // State D
    2'bxx; // Default (should never occur)

endmodule