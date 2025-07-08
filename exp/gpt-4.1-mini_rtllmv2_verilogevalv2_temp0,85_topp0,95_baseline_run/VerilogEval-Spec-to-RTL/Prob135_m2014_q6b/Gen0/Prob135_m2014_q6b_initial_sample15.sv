module TopModule(
    input wire clk,
    input wire rst,
    input wire [2:0] y,  // current state (for next-state logic)
    input wire w,
    output wire Y1
);

    // Output Y1 is y[1]
    assign Y1 = y[1];

    // Next-state logic for y[1] only
    // States encoding: A=000, B=001, C=010, D=011, E=100, F=101
    // From the state transitions, define next y[1] based on current y and w

    wire next_y1;

    // We'll use a combinational block or continuous assignment
    // to derive next y[1]. 
    // Define the next state for y[1] only according to the table:
    // A(000): y=000, input w
    // A->A if w=1 : next y = 000, y[1]=0
    // A->B if w=0 : next y=001, y[1]=0
    // So from A: next y[1]=0
    //
    // B(001):
    // B->C if w=0: C=010 y[1]=1
    // B->D if w=1: D=011 y[1]=1
    // So from B: next y[1]=1 regardless of w=0 or 1
    //
    // C(010):
    // C->E if w=0: E=100 y[1]=0
    // C->D if w=1: D=011 y[1]=1
    // So from C: next y[1]=w
    //
    // D(011):
    // D->F if w=0: F=101 y[1]=0
    // D->A if w=1: A=000 y[1]=0
    // So from D: next y[1]=0
    //
    // E(100):
    // E->E if w=0: E=100 y[1]=0
    // E->D if w=1: D=011 y[1]=1
    // So from E: next y[1]=w
    //
    // F(101):
    // F->C if w=0: C=010 y[1]=1
    // F->D if w=1: D=011 y[1]=1
    // So from F: next y[1]=1

    // Extract current state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next y1 logic:
    assign next_y1 = 
        (~y2 & ~y1 & ~y0) ? 1'b0 :         // A (000)
        (~y2 & ~y1 &  y0) ? 1'b1 :         // B (001)
        (~y2 &  y1 & ~y0) ? w      :       // C (010)
        (~y2 &  y1 &  y0) ? 1'b0 :         // D (011)
        ( y2 & ~y1 & ~y0) ? w      :       // E (100)
        ( y2 & ~y1 &  y0) ? 1'b1 : 1'b0;  // F (101), default 0 for other states (not used)

endmodule