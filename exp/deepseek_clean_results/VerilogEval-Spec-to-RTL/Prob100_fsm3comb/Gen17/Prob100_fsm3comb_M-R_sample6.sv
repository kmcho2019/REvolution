module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State encodings
localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Output is high only in state D
assign out = (state == D);

// State transition logic using continuous assignments
assign next_state[1] = (state == C) | 
                       (state == D & ~in) | 
                       (state == B & ~in);

assign next_state[0] = (state == A & in) | 
                       (state == B & in) | 
                       (state == D & in);

endmodule