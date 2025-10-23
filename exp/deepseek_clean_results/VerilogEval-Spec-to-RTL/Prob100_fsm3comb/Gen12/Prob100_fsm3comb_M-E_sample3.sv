module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State encoding with meaningful names
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Next state LUT [current_state][in] -> next_state
wire [1:0] next_state_lut [0:3][0:1] = '{
    '{A, B}, // State A: in=0->A, in=1->B
    '{C, B}, // State B: in=0->C, in=1->B
    '{A, D}, // State C: in=0->A, in=1->D
    '{C, B}  // State D: in=0->C, in=1->B
};

// Output is high only in state D (11)
assign out = (state == D);

// Next state is selected from LUT based on current state and input
assign next_state = next_state_lut[state][in];

endmodule