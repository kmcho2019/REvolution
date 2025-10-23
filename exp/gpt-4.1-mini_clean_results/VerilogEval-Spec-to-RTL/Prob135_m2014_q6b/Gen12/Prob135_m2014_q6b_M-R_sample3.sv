module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    // Define signals for each state for clarity
    wire A = (y == 3'b000);
    wire B = (y == 3'b001);
    wire C = (y == 3'b010);
    wire D = (y == 3'b011);
    wire E = (y == 3'b100);
    wire F = (y == 3'b101);

    // Derive y1_next from the FSM transitions:
    // States where next y1 is always 0: A, D
    // States where next y1 is always 1: B, F
    // States C and E depend on w:
    // C: w=0->E(y1=0), w=1->D(y1=1)
    // E: w=0->E(y1=0), w=1->D(y1=1)
    wire y1_next = (B | F) | ((C | E) & w);

    assign Y1 = y1_next;

endmodule