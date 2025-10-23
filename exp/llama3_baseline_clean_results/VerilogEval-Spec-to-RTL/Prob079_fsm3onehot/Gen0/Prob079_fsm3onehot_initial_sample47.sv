module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// One-hot encoding for states
wire is_A = (state == 4'b0001);
wire is_B = (state == 4'b0010);
wire is_C = (state == 4'b0100);
wire is_D = (state == 4'b1000);

// State transition logic
assign next_state[0] = (~in & is_A) | (~in & is_C) | (~in & is_D); // Next state is A (4'b0001)
assign next_state[1] = (in & is_A) | (~in & is_B) | (in & is_D); // Next state is B (4'b0010)
assign next_state[2] = (~in & is_B) | (in & is_C); // Next state is C (4'b0100)
assign next_state[3] = (in & is_C); // Next state is D (4'b1000)

// Output logic
assign out = is_D;

endmodule