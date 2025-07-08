module TopModule (
    input  [2:0] y,  // current state
    input        w,
    output       Y1
);

// y[2], y[1], y[0] correspond to bits of current state
// The states are encoded as:
// A = 000
// B = 001
// C = 010
// D = 011
// E = 100
// F = 101

// Implement next-state logic for y[1] only:

// We define a combinational expression for next y[1] (y1_next)
// Based on the transitions, derive next y[1] based on current y and w

// State transitions and next states:
// A(000):
//   w=0 -> B(001): y1_next=0
//   w=1 -> A(000): y1_next=0
// B(001):
//   w=0 -> C(010): y1_next=1
//   w=1 -> D(011): y1_next=1
// C(010):
//   w=0 -> E(100): y1_next=0
//   w=1 -> D(011): y1_next=1
// D(011):
//   w=0 -> F(101): y1_next=0
//   w=1 -> A(000): y1_next=0
// E(100):
//   w=0 -> E(100): y1_next=0
//   w=1 -> D(011): y1_next=1
// F(101):
//   w=0 -> C(010): y1_next=1
//   w=1 -> D(011): y1_next=1

// Let's summarize y1_next for each (y, w):

// y   w | y1_next
// 000 0 | 0
// 000 1 | 0
// 001 0 | 1
// 001 1 | 1
// 010 0 | 0
// 010 1 | 1
// 011 0 | 0
// 011 1 | 0
// 100 0 | 0
// 100 1 | 1
// 101 0 | 1
// 101 1 | 1

// y = y[2] y[1] y[0]

wire y2 = y[2];
wire y1 = y[1];
wire y0 = y[0];

wire y1_next;

assign y1_next =
    (y == 3'b001) ? 1'b1 :                   // B, both w values
    (y == 3'b010) ? w :                      // C, w=1->1, w=0->0
    (y == 3'b100) ? w :                      // E, w=1->1, w=0->0
    (y == 3'b101) ? 1'b1 :                   // F, both w values
    (y == 3'b000) ? 1'b0 :                   // A
    (y == 3'b011) ? 1'b0 :                   // D
    1'b0;                                   // default (not used states)

assign Y1 = y1;

endmodule