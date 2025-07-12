module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // Decode current one-hot states
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Compute next_state bits based on transitions
    assign next_state[0] = (~in & A) | (~in & C);           // A and C transition to A on in=0
    assign next_state[1] = ( in & A) | ( in & B) | ( in & D); // A,B,D transition to B on in=1
    assign next_state[2] = (~in & B) | (~in & D);           // B and D transition to C on in=0
    assign next_state[3] =  in & C;                          // C transitions to D on in=1

    // Output is 1 only when state D is active
    assign out = D;

endmodule