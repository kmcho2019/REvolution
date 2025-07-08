module TopModule (
    input  [2:0] y,
    input        w,
    output       Y1
);
    // Since only next state logic for y[1] is needed,
    // derive y1_next from current y and w using FSM transitions.

    // Current state encodings:
    // A=000, B=001, C=010, D=011, E=100, F=101
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Compute next state for y[1] (y1_next)
    // We analyze transitions by state and input:

    // For each state, define next state y1 bit:
    // State A (000): w=0 -> B(001) y1=0, w=1 -> A(000) y1=0
    // State B (001): w=0 -> C(010) y1=1, w=1 -> D(011) y1=1
    // State C (010): w=0 -> E(100) y1=0, w=1 -> D(011) y1=1
    // State D (011): w=0 -> F(101) y1=0, w=1 -> A(000) y1=0
    // State E (100): w=0 -> E(100) y1=0, w=1 -> D(011) y1=1
    // State F (101): w=0 -> C(010) y1=1, w=1 -> D(011) y1=1

    // Express y1_next using logic equations derived from above:

    // Define states as signals for clarity:
    wire state_A = (y == 3'b000);
    wire state_B = (y == 3'b001);
    wire state_C = (y == 3'b010);
    wire state_D = (y == 3'b011);
    wire state_E = (y == 3'b100);
    wire state_F = (y == 3'b101);

    // From transitions:
    // y1_next = 1 if
    // (state_B) or
    // (state_C & w) or
    // (state_E & w) or
    // (state_F) or
    // (state_B & w) (already covered by state_B)
    // state_B always goes to y1=1 regardless w
    // state_C w=1 -> y1=1
    // state_E w=1 -> y1=1
    // state_F always y1=1 regardless w

    // So y1_next = (state_B) | (state_F) | (state_C & w) | (state_E & w)

    assign Y1 = y1;

endmodule