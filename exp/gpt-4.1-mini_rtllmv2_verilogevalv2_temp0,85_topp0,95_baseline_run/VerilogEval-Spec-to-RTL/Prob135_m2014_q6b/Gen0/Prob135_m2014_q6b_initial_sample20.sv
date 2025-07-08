module TopModule (
    input  wire [2:0] y,
    input  wire w,
    output wire Y1
);

    wire next_y1;

    // State encoding:
    // A=000, B=001, C=010, D=011, E=100, F=101
    // y[2] y[1] y[0]

    // Extract current state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next-state logic for y[1]:
    // Based on the FSM transitions and states, derive next y[1]:
    // We'll analyze each state and input w to find next y[1]:

    // State A(000):
    // w=0: next state B(001) => y1=0
    // w=1: next state A(000) => y1=0

    // State B(001):
    // w=0: next C(010) => y1=1
    // w=1: next D(011) => y1=1

    // State C(010):
    // w=0: next E(100) => y1=0
    // w=1: next D(011) => y1=1

    // State D(011):
    // w=0: next F(101) => y1=0
    // w=1: next A(000) => y1=0

    // State E(100):
    // w=0: next E(100) => y1=0
    // w=1: next D(011) => y1=1

    // State F(101):
    // w=0: next C(010) => y1=1
    // w=1: next D(011) => y1=1

    // Summarize next_y1 values:

    // A(000): 0
    // B(001): 1
    // C(010): w
    // D(011): 0
    // E(100): w
    // F(101): 1

    // We'll write boolean logic for next_y1:

    // For B and F (states with y2=0, y1=0 or 1, y0=1, y1=0 or 1):
    // B (0 0 1): next_y1=1
    // F (1 0 1): next_y1=1
    // Both have y0=1 and y1=0 or 1, so better to handle individually.

    // Let's write logic as sum of minterms:

    // next_y1 = (B) + (F) + (C and w) + (E and w)

    // B: y2=0, y1=0, y0=1
    wire B = (~y2) & (~y1) & (y0);
    // F: y2=1, y1=0, y0=1
    wire F = (y2) & (~y1) & (y0);
    // C: y2=0, y1=1, y0=0
    wire C = (~y2) & (y1) & (~y0);
    // E: y2=1, y1=0, y0=0
    wire E = (y2) & (~y1) & (~y0);

    assign next_y1 = B | F | (C & w) | (E & w);

    assign Y1 = y1;

endmodule