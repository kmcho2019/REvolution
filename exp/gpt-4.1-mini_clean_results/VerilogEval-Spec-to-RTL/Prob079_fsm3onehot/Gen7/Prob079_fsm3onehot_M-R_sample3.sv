module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Define wires for current states for clarity
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Compute each next state bit by OR-ing transitions from possible current states
    wire next_A = (A & ~in) | (C & ~in);
    wire next_B = (A & in)  | (B & in)  | (D & in);
    wire next_C = (B & ~in) | (D & ~in);
    wire next_D = (C & in);

    // Assign next state output
    assign next_state = {next_D, next_C, next_B, next_A};

    // Moore output depends only on state D
    assign out = D;

endmodule