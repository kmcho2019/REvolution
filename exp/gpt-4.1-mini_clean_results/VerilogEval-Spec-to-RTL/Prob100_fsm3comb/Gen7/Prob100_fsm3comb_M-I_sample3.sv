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

// Output logic: out = 1 only in state D (2'b11)
assign out = (state == D);

// Next state logic derived from table:
// For clarity, define state bits:
wire s1 = state[1];
wire s0 = state[0];

// Derive next_state[1] (MSB) truth table from transitions:
// State | in=0 -> next_state | in=1 -> next_state
// A(00) | 00                 | 01
// B(01) | 10                 | 01
// C(10) | 00                 | 11
// D(11) | 10                 | 01
//
// Let's write next_state[1]:
// For each (state,in):
// (A,0): next_state=00 => bit1=0
// (A,1): next_state=01 => bit1=0
// (B,0): next_state=10 => bit1=1
// (B,1): next_state=01 => bit1=0
// (C,0): next_state=00 => bit1=0
// (C,1): next_state=11 => bit1=1
// (D,0): next_state=10 => bit1=1
// (D,1): next_state=01 => bit1=0
//
// truth table for next_state[1] as function of s1 s0 in:
//
// s1 s0 in | next_state[1]
// 0  0  0 | 0
// 0  0  1 | 0
// 0  1  0 | 1
// 0  1  1 | 0
// 1  0  0 | 0
// 1  0  1 | 1
// 1  1  0 | 1
// 1  1  1 | 0
//
// Simplify:
// next_state[1] = (~s1 & s0 & ~in) | (s1 & ~s0 & in) | (s1 & s0 & ~in)
//               = ( (~s1 & s0 & ~in) ) | ( s1 & ( (~s0 & in) | (s0 & ~in) ) )
//               = ( (~s1 & s0 & ~in) ) | ( s1 & ( s0 ^ in ) )
//
// Next next_state[0]:
// From transitions:
//
// (A,0): 00 -> bit0=0
// (A,1): 01 -> bit0=1
// (B,0): 10 -> bit0=0
// (B,1): 01 -> bit0=1
// (C,0): 00 -> bit0=0
// (C,1): 11 -> bit0=1
// (D,0): 10 -> bit0=0
// (D,1): 01 -> bit0=1
//
// truth table:
//
// s1 s0 in | next_state[0]
// 0  0  0 | 0
// 0  0  1 | 1
// 0  1  0 | 0
// 0  1  1 | 1
// 1  0  0 | 0
// 1  0  1 | 1
// 1  1  0 | 0
// 1  1  1 | 1
//
// next_state[0] = in (independent of state bits)
//
// Hence:
// next_state[0] = in
// next_state[1] = (~s1 & s0 & ~in) | (s1 & (s0 ^ in))

assign next_state[1] = (~s1 & s0 & ~in) | (s1 & (s0 ^ in));
assign next_state[0] = in;

endmodule