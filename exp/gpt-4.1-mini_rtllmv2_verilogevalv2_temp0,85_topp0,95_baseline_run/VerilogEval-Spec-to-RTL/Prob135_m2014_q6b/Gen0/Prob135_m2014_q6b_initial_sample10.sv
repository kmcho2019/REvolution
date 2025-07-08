module TopModule(
    input [2:0] y,
    input w,
    output Y1
);
    wire y1_next;

    // Extract current state bits
    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    // According to given state codes:
    // A=000, B=001, C=010, D=011, E=100, F=101

    // Next state for y[1] only, from the state transitions:
    // Write down transitions and map to next y[1]:

    // State A(000): y[1]=0
    // w=0 -> B(001): y[1]=0
    // w=1 -> A(000): y[1]=0

    // State B(001): y[1]=0
    // w=0 -> C(010): y[1]=1
    // w=1 -> D(011): y[1]=1

    // State C(010): y[1]=1
    // w=0 -> E(100): y[1]=0
    // w=1 -> D(011): y[1]=1

    // State D(011): y[1]=1
    // w=0 -> F(101): y[1]=0
    // w=1 -> A(000): y[1]=0

    // State E(100): y[1]=0
    // w=0 -> E(100): y[1]=0
    // w=1 -> D(011): y[1]=1

    // State F(101): y[1]=0
    // w=0 -> C(010): y[1]=1
    // w=1 -> D(011): y[1]=1

    // Logic table for next y[1]:

    // Current y = y2 y1 y0, input w, next y1

    // A(000): y2=0,y1=0,y0=0
    // w=0 -> next y1=0
    // w=1 -> next y1=0

    // B(001): y2=0,y1=0,y0=1
    // w=0 -> 1
    // w=1 -> 1

    // C(010): y2=0,y1=1,y0=0
    // w=0 -> 0
    // w=1 -> 1

    // D(011): y2=0,y1=1,y0=1
    // w=0 -> 0
    // w=1 -> 0

    // E(100): y2=1,y1=0,y0=0
    // w=0 -> 0
    // w=1 -> 1

    // F(101): y2=1,y1=0,y0=1
    // w=0 -> 1
    // w=1 -> 1

    // Build expression for y1_next:

    // Let's create a truth table (y2,y1,y0,w) vs y1_next:

    // y2 y1 y0 w | y1_next
    // 0  0  0  0 | 0
    // 0  0  0  1 | 0
    // 0  0  1  0 | 1
    // 0  0  1  1 | 1
    // 0  1  0  0 | 0
    // 0  1  0  1 | 1
    // 0  1  1  0 | 0
    // 0  1  1  1 | 0
    // 1  0  0  0 | 0
    // 1  0  0  1 | 1
    // 1  0  1  0 | 1
    // 1  0  1  1 | 1

    // Simplify logically:

    // y1_next = ( !y2 & !y1 & y0 ) // state B
    //          | ( !y2 & y1 & !y0 & w ) // state C w=1
    //          | ( y2 & !y1 & ( (!y0 & w) | y0 ) ); // E and F states

    // Note for F (101), next y1=1 regardless of w
    // For E (100), next y1=1 only if w=1

    // Simplify for E and F:
    // (y2 & !y1 & ( (!y0 & w) | y0 )) = (y2 & !y1 & (y0 | (!y0 & w))) = (y2 & !y1 & (y0 | w))

    assign y1_next = ((!y2) & (!y1) & y0) | 
                     ((!y2) & y1 & (!y0) & w) | 
                     (y2 & (!y1) & (y0 | w));

    assign Y1 = y[1];

endmodule