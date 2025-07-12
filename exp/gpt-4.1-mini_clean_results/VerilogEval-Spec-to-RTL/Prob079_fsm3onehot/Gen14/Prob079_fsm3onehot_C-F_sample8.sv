module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);
    // Named wires for current state bits and input complement for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];
    wire in_n = ~in;

    // Next state logic: minimal expressions derived by inspection and factored
    assign next_state[0] = in_n & (A | C);      // Next A
    assign next_state[1] = in  & (A | B | D);   // Next B
    assign next_state[2] = in_n & (B | D);      // Next C
    assign next_state[3] = in  & C;             // Next D

    // Output logic: Moore output depends only on state D
    assign out = D;

endmodule