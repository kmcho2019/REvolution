module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y1_next;

    // Next state logic for y[1]
    // States encoding: A=000, B=001, C=010, D=011, E=100, F=101
    // From the state transition diagram, the next-state y[1] bit depends on current y and w
    //
    // We'll define a combinational logic for y[1] next state.
    //
    // The transitions affecting y[1]:
    // From A(000):
    //   w=0 => B(001) y=001 y[1]=0
    //   w=1 => A(000) y=000 y[1]=0
    //
    // From B(001):
    //   w=0 => C(010) y=010 y[1]=1
    //   w=1 => D(011) y=011 y[1]=1
    //
    // From C(010):
    //   w=0 => E(100) y=100 y[1]=0
    //   w=1 => D(011) y=011 y[1]=1
    //
    // From D(011):
    //   w=0 => F(101) y=101 y[1]=0
    //   w=1 => A(000) y=000 y[1]=0
    //
    // From E(100):
    //   w=0 => E(100) y=100 y[1]=0
    //   w=1 => D(011) y=011 y[1]=1
    //
    // From F(101):
    //   w=0 => C(010) y=010 y[1]=1
    //   w=1 => D(011) y=011 y[1]=1
    //
    // Let's implement this directly using combinational logic.
    // Extract y bits for clarity
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // We'll implement the next state bit y1_next as a combinational expression:
    // Following from the table above, y1_next is 1 in these transitions:
    // B->C or B->D (w=0 or 1, from B(001)), so when y=001 (y2=0, y1=0, y0=1) => y1_next=1
    // C->D (w=1), y=010 w=1 => y1_next=1
    // F->C or F->D (w=0 or 1), y=101 => y2=1,y1=0,y0=1 => y1_next=1
    // E->D (w=1), y=100 w=1 => y1_next=1
    //
    // Else y1_next=0

    assign y1_next = 
          // State B (001)
          (~y2 & ~y1 & y0)
          |
          // State C (010) and w=1
          ((~y2 & y1 & ~y0) & w)
          |
          // State E (100) and w=1
          ((y2 & ~y1 & ~y0) & w)
          |
          // State F (101)
          (y2 & ~y1 & y0);

    assign Y1 = y1;

endmodule