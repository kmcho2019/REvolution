module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    wire next_y1 = 
        // Cases where y[1] becomes 1
        ((y == 3'b001 && w) ||  // B->D (001->011)
         (y == 3'b010 && w) ||  // C->D (010->011)
         (y == 3'b100 && w)) || // E->D (100->011)
        // Cases where y[1] stays 1
        ((y == 3'b011 && w) ||  // D->A (011->000) but y[1] changes to 0
         (y == 3'b100 && ~w) ||// E->E (100->100)
         (y == 3'b101 && w));  // F->D (101->011)

    // Alternative implementation using case-like structure with assign
    wire next_y1_alt = 
        (y == 3'b000) ? 1'b0 :  // A stays or goes to B (y[1]=0 in both)
        (y == 3'b001) ? w :      // B->D (1) or B->C (0)
        (y == 3'b010) ? w :      // C->D (1) or C->E (0)
        (y == 3'b011) ? ~w :     // D->F (0) or D->A (0)
        (y == 3'b100) ? 1'b1 :   // E stays or goes to D (y[1]=1 in both)
        (y == 3'b101) ? w :      // F->C (0) or F->D (1)
        1'b0;                    // default

    // Using the more reliable alternative implementation
    assign Y1 = next_y1_alt;

endmodule