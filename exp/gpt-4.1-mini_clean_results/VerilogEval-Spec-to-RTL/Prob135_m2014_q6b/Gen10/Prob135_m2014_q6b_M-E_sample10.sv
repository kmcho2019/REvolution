module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // State encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101

    // Next state y1 bit (second bit of next state y):
    // From transitions:
    // A(000): w=0->B(001:y1=0), w=1->A(000:y1=0)
    // B(001): w=0->C(010:y1=1), w=1->D(011:y1=1)
    // C(010): w=0->E(100:y1=0), w=1->D(011:y1=1)
    // D(011): w=0->F(101:y1=0), w=1->A(000:y1=0)
    // E(100): w=0->E(100:y1=0), w=1->D(011:y1=1)
    // F(101): w=0->C(010:y1=1), w=1->D(011:y1=1)

    // Let's define y bits as y[2], y[1], y[0]
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Derive next y1 (y1_next) as per transition:
    // Conditions when next y1 = 1:

    // State B(001): next y1=1 regardless of w
    // => y=001 -> y2=0, y1=0, y0=1

    // State C(010), w=1: next y1=1
    // => y=010, w=1

    // State E(100), w=1: next y1=1
    // => y=100, w=1

    // State F(101), w=0 or 1: next y1=1
    // => y=101

    // So next_y1 = (y==B) | (y==C & w) | (y==E & w) | (y==F)

    wire is_B = ~y2 & ~y1 & y0;
    wire is_C = ~y2 & y1 & ~y0;
    wire is_E = y2 & ~y1 & ~y0;
    wire is_F = y2 & ~y1 & y0;

    wire y1_next = is_B | (is_C & w) | (is_E & w) | is_F;

    assign Y1 = y1_next;

endmodule