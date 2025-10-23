module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Decode current state into individual state signals
wire state_A = (state == 4'b0001);
wire state_B = (state == 4'b0010);
wire state_C = (state == 4'b0100);
wire state_D = (state == 4'b1000);

// Derive next state logic equations
assign next_state[0] = (~in & state_A) | (~in & state_C) | (in & state_B) | (in & state_D);
assign next_state[1] = (in & state_A) | (~in & state_B) | (in & state_B) | (~in & state_D);
assign next_state[2] = (~in & state_B) | (in & state_C);
assign next_state[3] = (in & state_C);

// Derive output logic equation
assign out = state_D;

endmodule