module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

    // Current state bits
    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    // next_y1 logic from the state transitions
    // States: A=000, B=001, C=010, D=011, E=100, F=101
    // Implement next_y1 only

    // Derive next_y1 by enumerating next states for y[1] bit:

    // For each state y=abc, w=input:
    // State A(000):
    //   w=0 -> B(001) -> next_y1=0
    //   w=1 -> A(000) -> next_y1=0
    // State B(001):
    //   w=0 -> C(010) -> next_y1=1
    //   w=1 -> D(011) -> next_y1=1
    // State C(010):
    //   w=0 -> E(100) -> next_y1=0
    //   w=1 -> D(011) -> next_y1=1
    // State D(011):
    //   w=0 -> F(101) -> next_y1=0
    //   w=1 -> A(000) -> next_y1=0
    // State E(100):
    //   w=0 -> E(100) -> next_y1=0
    //   w=1 -> D(011) -> next_y1=1
    // State F(101):
    //   w=0 -> C(010) -> next_y1=1
    //   w=1 -> D(011) -> next_y1=1

    // Map inputs to next_y1:

    // Table:

    // y2 y1 y0 | w | next_y1
    // ----------------------
    // 0  0  0  | 0 | 0
    // 0  0  0  | 1 | 0
    // 0  0  1  | 0 | 1
    // 0  0  1  | 1 | 1
    // 0  1  0  | 0 | 0
    // 0  1  0  | 1 | 1
    // 0  1  1  | 0 | 0
    // 0  1  1  | 1 | 0
    // 1  0  0  | 0 | 0
    // 1  0  0  | 1 | 1
    // 1  0  1  | 0 | 1
    // 1  0  1  | 1 | 1

    // Express next_y1 logic in minimized form:
    // next_y1 = ( ~y2 & ~y1 & y0 ) // B states, always 1
    //          | ( ~y2 & y1 & w )   // C & E states when w=1
    //          | ( y2 & ~y1 & (w | y0) )
    //
    // Simplified Boolean expression:

    wire next_y1 = 
        (~y2 & ~y1 & y0)               // State B (001)
      | (~y2 & y1 & w)                // States C(010) and E(100) when w=1
      | (y2 & ~y1 & (w | y0));       // States F(101) and E(100)

    assign Y1 = y1;

endmodule