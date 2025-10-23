module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State encoding constants
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// Logic for next_state
assign next_state[0] = (state == A && !in) || (state == C && in) || (state == D && !in); // Next state A
assign next_state[1] = (state == A && in) || (state == B && (in || !in)) || (state == D && in); // Next state B
assign next_state[2] = (state == B && !in) || (state == C && !in); // Next state C
assign next_state[3] = (state == C && in); // Next state D

// Logic for output
assign out = (state == D);

endmodule