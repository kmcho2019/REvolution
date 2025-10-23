module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Decode current state
    wire state_A = (y == 3'b000);
    wire state_B = (y == 3'b001);
    wire state_C = (y == 3'b010);
    wire state_D = (y == 3'b011);
    wire state_E = (y == 3'b100);
    wire state_F = (y == 3'b101);

    // Compute next state y[1] bit based on FSM transitions:
    // y1_next = 1 for:
    // - next state B (001): from B regardless of w
    // - next state C (010): from C if w==1
    // - next state E (100): from E if w==1
    // - next state F (101): from F regardless of w

    wire next_y1_B = state_B;           // y next = B (001) => y1=0, but actually y1=0? Check again
    wire next_y1_C = state_C & w;       // from C next = D or E depending on w
    wire next_y1_E = state_E & w;
    wire next_y1_F = state_F;

    // Carefully re-check encoding:
    // B = 001 => y1=0
    // C = 010 => y1=1
    // D = 011 => y1=1
    // E = 100 => y1=0
    // F = 101 => y1=0
    //
    // Actually original states:
    // A (000): y1=0
    // B (001): y1=0
    // C (010): y1=1
    // D (011): y1=1
    // E (100): y1=0
    // F (101): y1=0
    //
    // So y1=1 for states C and D only.

    // The original problem states output Y1 = y[1].
    // So output Y1 is y[1] of the current state y, not next state.
    // The task is to implement next state logic for y[1].
    // So the expression for next y1 bit must reflect the bit y1 of the next state.

    // From FSM transitions, next state y1 bit for each state and w:
    // A(000): next state A or B -> next y1 = 0
    // B(001): next states C or D -> y1=1
    // C(010): next states E or D -> E(y1=0), D(y1=1) so depends on w
    // D(011): next states A or F -> y1=0
    // E(100): next states E or D -> y1 depends on w (0 or 1)
    // F(101): next states C or D -> y1=1

    // Thus next y1 bit logic:
    // next_y1 = 
    //   (state_B)              // from B, next y1=1
    //   | (state_C & w)        // from C, next y1=1 if w=1 (goes to D)
    //   | (state_E & w)        // from E, next y1=1 if w=1 (goes to D)
    //   | (state_F)            // from F, next y1=1 (goes to C or D)

    wire next_y1 = (state_B) | (state_C & w) | (state_E & w) | (state_F);

    assign Y1 = next_y1;

endmodule