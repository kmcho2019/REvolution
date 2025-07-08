module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

// State encoding for readability
// A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000
wire A = state[0];
wire B = state[1];
wire C = state[2];
wire D = state[3];

// Next state logic derived by inspection and one-hot encoding
assign next_state[0] = (A & ~in) | (C & ~in);      // Next A: from A(0) or C(0)
assign next_state[1] = (A &  in) | (B &  in) | (D &  in); // Next B: from A(1), B(1), or D(1)
assign next_state[2] = (B & ~in) | (D & ~in);      // Next C: from B(0) or D(0)
assign next_state[3] = (C &  in);                   // Next D: from C(1)

// Output logic (Moore): output=1 only in state D
assign out = D;

endmodule