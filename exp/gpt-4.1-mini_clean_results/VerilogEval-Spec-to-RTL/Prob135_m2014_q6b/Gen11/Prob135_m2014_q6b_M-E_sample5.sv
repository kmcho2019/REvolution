module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // State encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101

    // Next states from FSM:
    // From A(000): w=0 -> B(001), y1_next=0; w=1 -> A(000), y1_next=0
    // From B(001): w=0 -> C(010), y1_next=1; w=1 -> D(011), y1_next=1
    // From C(010): w=0 -> E(100), y1_next=0; w=1 -> D(011), y1_next=1
    // From D(011): w=0 -> F(101), y1_next=0; w=1 -> A(000), y1_next=0
    // From E(100): w=0 -> E(100), y1_next=0; w=1 -> D(011), y1_next=1
    // From F(101): w=0 -> C(010), y1_next=1; w=1 -> D(011), y1_next=1

    // Derive y1_next as a function of y and w:
    // Implement y1_next = f(y,w)

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Using the state and w info, y1_next is:
    // For A(000) (y2=0,y1=0,y0=0): y1_next=0
    // For B(001) (0,0,1): y1_next=1
    // For C(010) (0,1,0): y1_next=w
    // For D(011) (0,1,1): y1_next=0
    // For E(100) (1,0,0): y1_next=w
    // For F(101) (1,0,1): y1_next=1

    // Expressed logically:

    // Detect states:
    wire isA = (~y2) & (~y1) & (~y0);
    wire isB = (~y2) & (~y1) & y0;
    wire isC = (~y2) & y1 & (~y0);
    wire isD = (~y2) & y1 & y0;
    wire isE = y2 & (~y1) & (~y0);
    wire isF = y2 & (~y1) & y0;

    // Compose output:
    assign Y1 = (isB) |                // B always 1
                (isC & w) |            // C depends on w
                (isE & w) |            // E depends on w
                (isF);                 // F always 1

endmodule