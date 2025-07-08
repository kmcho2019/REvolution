module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Current state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Compute next state's y1 bit (y1_next) based on current y and w
    // Let's write the truth table for next y1 bit from given state transitions

    // States: A=000, B=001, C=010, D=011, E=100, F=101
    // Transitions:
    // A(000) w=0 -> B(001), y1_next=0
    // A(000) w=1 -> A(000), y1_next=0
    // B(001) w=0 -> C(010), y1_next=1
    // B(001) w=1 -> D(011), y1_next=1
    // C(010) w=0 -> E(100), y1_next=0
    // C(010) w=1 -> D(011), y1_next=1
    // D(011) w=0 -> F(101), y1_next=0
    // D(011) w=1 -> A(000), y1_next=0
    // E(100) w=0 -> E(100), y1_next=0
    // E(100) w=1 -> D(011), y1_next=1
    // F(101) w=0 -> C(010), y1_next=1
    // F(101) w=1 -> D(011), y1_next=1

    // Let's enumerate current state and w with next y1:

    // State   w  next y1
    // 000(A)  0  0
    // 000(A)  1  0
    // 001(B)  0  1
    // 001(B)  1  1
    // 010(C)  0  0
    // 010(C)  1  1
    // 011(D)  0  0
    // 011(D)  1  0
    // 100(E)  0  0
    // 100(E)  1  1
    // 101(F)  0  1
    // 101(F)  1  1

    // From this, derive y1_next logic

    // Expression in sum of minterms for y1_next:

    // y1_next = (B & ~w) | (B & w) | (C & w) | (~y2 & y1 & ~y0 & w) | (F & ~w) | F
    // Simplify:

    // B = 001 = ~y2 & ~y1 & y0
    // C = 010 = ~y2 & y1 & ~y0
    // D = 011 = ~y2 & y1 & y0
    // E = 100 = y2 & ~y1 & ~y0
    // F = 101 = y2 & ~y1 & y0

    // Let's rewrite:

    // y1_next = (B) + (C & w) + (E & w) + (F)

    // B = ~y2 & ~y1 & y0
    // C = ~y2 & y1 & ~y0
    // E = y2 & ~y1 & ~y0
    // F = y2 & ~y1 & y0

    // y1_next = B + (C & w) + (E & w) + F

    // Implement this expression:

    wire B = (~y2) & (~y1) & y0;
    wire C = (~y2) & y1 & (~y0);
    wire E = y2 & (~y1) & (~y0);
    wire F = y2 & (~y1) & y0;

    wire y1_next = B | (C & w) | (E & w) | F;

    assign Y1 = y1;

endmodule