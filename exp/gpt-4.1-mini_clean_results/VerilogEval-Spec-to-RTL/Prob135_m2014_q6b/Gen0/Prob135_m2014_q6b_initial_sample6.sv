module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

// y[2:0] encode states A-F as 000 to 101 respectively
// Output Y1 is y[1]
assign Y1 = y[1];

// Implement next state logic for y[1] only based on the FSM transitions:
// From the transitions, derive y[1]_next as a function of current y and w

// To do this, first list the states and their y values:

// States:
// A: 000
// B: 001
// C: 010
// D: 011
// E: 100
// F: 101

// From transitions and only focusing on y[1] bit next value:
// We'll analyze the transitions' destination states and extract the next y[1].

// Transitions:
// A(000): 
//   input=0 -> B(001), y_next[1]=0
//   input=1 -> A(000), y_next[1]=0
// B(001):
//   input=0 -> C(010), y_next[1]=1
//   input=1 -> D(011), y_next[1]=1
// C(010):
//   input=0 -> E(100), y_next[1]=0
//   input=1 -> D(011), y_next[1]=1
// D(011):
//   input=0 -> F(101), y_next[1]=0
//   input=1 -> A(000), y_next[1]=0
// E(100):
//   input=0 -> E(100), y_next[1]=0
//   input=1 -> D(011), y_next[1]=1
// F(101):
//   input=0 -> C(010), y_next[1]=1
//   input=1 -> D(011), y_next[1]=1

// Make truth table of next y[1] vs current y and w:

// y      w | y_next[1]
// 000 A   0 | 0
// 000 A   1 | 0
// 001 B   0 | 1
// 001 B   1 | 1
// 010 C   0 | 0
// 010 C   1 | 1
// 011 D   0 | 0
// 011 D   1 | 0
// 100 E   0 | 0
// 100 E   1 | 1
// 101 F   0 | 1
// 101 F   1 | 1

// For y=110,111 states are unused, treat them as don't care.

// Write the expression for y_next[1] as a function of y and w.

// Let's write out minterms for y_next[1] = 1:

// Cases with output 1:

// (y=001, w=0) ->  y[2]=0,y[1]=0,y[0]=1, w=0
// (y=001, w=1)
// (y=010, w=1)
// (y=100, w=1)
// (y=101, w=0)
// (y=101, w=1)

// Boolean expression:
// We can write as sum of products:

// 1) y=001 => y2=0,y1=0,y0=1 => !y2 & !y1 & y0
//   For w=0 or 1: so (!y2 & !y1 & y0)

// 2) y=010,w=1 => y2=0,y1=1,y0=0,w=1 => !y2 & y1 & !y0 & w

// 3) y=100,w=1 => y2=1,y1=0,y0=0,w=1 => y2 & !y1 & !y0 & w

// 4) y=101,w=0 or 1 => y2=1,y1=0,y0=1
//  For w=0 or 1 => y2 & !y1 & y0

// So combine cases with w don't care:

// y_next[1] = (!y2 & !y1 & y0)         // state B
//          + (!y2 & y1 & !y0 & w)     // state C, w=1
//          + (y2 & !y1 & !y0 & w)     // state E, w=1
//          + (y2 & !y1 & y0)          // state F

assign y1_next = 
    (~y[2] & ~y[1] & y[0]) |            // B
    (~y[2] &  y[1] & ~y[0] & w) |       // C and w=1
    ( y[2] & ~y[1] & ~y[0] & w) |       // E and w=1
    ( y[2] & ~y[1] & y[0]);              // F

endmodule