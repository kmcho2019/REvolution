module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Current state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next state y[1] bit logic derived from FSM:

    // From FSM transitions and state encoding (A=000, B=001, C=010, D=011, E=100, F=101),
    // and next states (see original mapping),
    // we enumerate the conditions where y1_next = 1:

    // Next states with y1=1 are: B(001), C(010), E(100), F(101)
    // Considering transitions:
    // y=001(B): next y1=1 regardless of w
    // y=010(C): next y1=w
    // y=011(D): next y1=0
    // y=100(E): next y1=w
    // y=101(F): next y1=1
    // y=000(A): next y1=0

    // Expressing the function y1_next:
    // y1_next = (y == 001) 
    //         + ((y == 010) & w) 
    //         + ((y == 100) & w)
    //         + (y == 101)

    // Since equality checks are costly, we rewrite using minterms:

    // (y == 001): ~y2 & ~y1 & y0
    // (y == 010): ~y2 & y1 & ~y0
    // (y == 100): y2 & ~y1 & ~y0
    // (y == 101): y2 & ~y1 & y0

    // So,
    // y1_next = (~y2 & ~y1 & y0)
    //         + (~y2 & y1 & ~y0 & w)
    //         + (y2 & ~y1 & ~y0 & w)
    //         + (y2 & ~y1 & y0)

    assign Y1 = 
          (~y2 & ~y1 & y0)
        | ((~y2 & y1 & ~y0) & w)
        | ((y2 & ~y1 & ~y0) & w)
        | (y2 & ~y1 & y0);

endmodule