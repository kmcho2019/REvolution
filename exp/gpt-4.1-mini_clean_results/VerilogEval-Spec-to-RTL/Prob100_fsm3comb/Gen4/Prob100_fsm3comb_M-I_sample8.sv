module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

// State encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Output logic: out = 1 when in state D
assign out = (state == D);

// Next state logic derived from table:
// next_state[1] = (state == B && in == 0) || (state == C && in == 1) || (state == D && in == 0)
// next_state[0] = (state == A && in == 1) || (state == B && in == 1) || (state == D && in == 1)

wire s0 = state[0];
wire s1 = state[1];
wire in0 = in;

assign next_state[1] = ((s1 == 0) && (s0 == 1) && (in0 == 0))  // B, in=0 -> C(10)
                     | ((s1 == 1) && (s0 == 0) && (in0 == 1))  // C, in=1 -> D(11)
                     | ((s1 == 1) && (s0 == 1) && (in0 == 0)); // D, in=0 -> C(10)

assign next_state[0] = ((s1 == 0) && (s0 == 0) && (in0 == 1))  // A, in=1 -> B(01)
                     | ((s1 == 0) && (s0 == 1) && (in0 == 1))  // B, in=1 -> B(01)
                     | ((s1 == 1) && (s0 == 1) && (in0 == 1)); // D, in=1 -> B(01)

// For A and C states with in=0, next_state[1:0] must be 00 (A) or 00 (A), which is 0 on both bits by default.

endmodule