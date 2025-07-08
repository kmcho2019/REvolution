module TopModule (
    input  wire [2:0] y,
    input  wire w,
    output wire Y1
);

// Next state logic for y[1], based on current y and w
// States A=000, B=001, C=010, D=011, E=100, F=101

// From the transition table, derive the next state bits for y[1]:
// We only implement next state logic for y[1], y[0] and y[2] remain unchanged here.

// Let's deduce y[1]_next for each current state and input w:

// State A (000):
// w=0: A --0--> B(001) y[1]=0->0
// w=1: A --1--> A(000) y[1]=0->0

// State B (001):
// w=0: B --0--> C(010) y[1]=0->1
// w=1: B --1--> D(011) y[1]=1->1

// State C (010):
// w=0: C --0--> E(100) y[1]=1->0
// w=1: C --1--> D(011) y[1]=1->1

// State D (011):
// w=0: D --0--> F(101) y[1]=0->0
// w=1: D --1--> A(000) y[1]=0->0

// State E (100):
// w=0: E --0--> E(100) y[1]=0->0
// w=1: E --1--> D(011) y[1]=1->1

// State F (101):
// w=0: F --0--> C(010) y[1]=1->1
// w=1: F --1--> D(011) y[1]=1->1

// Let's write truth table for y[1]_next:

// y[2] y[1] y[0] w | y1_next
//  0    0    0  0 | 0
//  0    0    0  1 | 0
//  0    0    1  0 | 1
//  0    0    1  1 | 1
//  0    1    0  0 | 0
//  0    1    0  1 | 1
//  0    1    1  0 | 0
//  0    1    1  1 | 0
//  1    0    0  0 | 0
//  1    0    0  1 | 1
//  1    0    1  0 | 1
//  1    0    1  1 | 1

// Implement logic equation for y1_next using sum of minterms or simplify:

// We'll implement as a combinational expression:

assign Y1 = y[1];

endmodule