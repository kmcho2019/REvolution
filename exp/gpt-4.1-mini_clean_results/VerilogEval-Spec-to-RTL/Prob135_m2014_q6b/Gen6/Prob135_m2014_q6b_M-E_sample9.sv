module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire A = (y == 3'b000);
    wire B = (y == 3'b001);
    wire C = (y == 3'b010);
    wire D = (y == 3'b011);
    wire E = (y == 3'b100);
    wire F = (y == 3'b101);

    // From state diagram and transitions:
    // next_y1 = 1 if next state has y[1] = 1, i.e.,
    // B (001), C(010), D(011), E(100), F(101)
    // Evaluate which inputs lead to these:
    // Next y1=1 for:
    // B from A on 0 (A=0->B=1)
    // C from B on 0 and F on 0 from D (see transitions)
    // D from B on 1, C on 1, E on 1, F on 1, D on 1 from D
    // E from C on 0 with w=0, E on 0 with w=0 (E loops on 0 when w=0)
    // F is reached from D on 0 with w=0 and E on 0 with w=0

    // Simplify by explicit next state derivation:
    // Since the problem states implementing just next y[1] logic,
    // we use the transitions:

    // Next y1 is 1 if next state is B, C, D, E, or F (those states with y1=1)
    // Next state is:

    // From A(000):
    //   y=0 -> B(001): y1=0 -> no (B has y1=0)
    //   y=1 -> A(000): y1=0 -> no
    // From B(001):
    //   y=0 -> C(010): y1=1 -> yes
    //   y=1 -> D(011): y1=1 -> yes
    // From C(010):
    //   y=0 -> E(100): y1=0 -> no
    //   y=1 -> D(011): y1=1 -> yes
    // From D(011):
    //   y=0 -> F(101): y1=0 -> no
    //   y=1 -> A(000): y1=0 -> no
    // From E(100):
    //   y=0 -> E(100): y1=0 -> no
    //   y=1 -> D(011): y1=1 -> yes
    // From F(101):
    //   y=0 -> C(010): y1=1 -> yes
    //   y=1 -> D(011): y1=1 -> yes

    // Let's define next_y1 logic from this:

    // next_y1 = 
    // (B & ~w)            // from B state with w=0 next y1=1 (goes to C)
    // | (B & w)           // from B state with w=1 next y1=1 (goes to D)
    // | (C & w)           // from C state with w=1 next y1=1 (goes to D)
    // | (E & w)           // from E state with w=1 next y1=1 (goes to D)
    // | (F & ~w)          // from F state with w=0 next y1=1 (goes to C)
    // | (F & w);          // from F state with w=1 next y1=1 (goes to D)

    // Actually, from B both inputs lead to y1=1 next states, so B directly sets next_y1=1

    // From E, only w=1 leads to D which has y1=1, so E & w

    // From F, both inputs lead to states with y1=1, so F

    // From C, only w=1 leads to D (y1=1)

    assign Y1 = B | (C & w) | (E & w) | F;

endmodule