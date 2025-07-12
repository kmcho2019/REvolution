module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1,
    output       y1_next_out  // expose next-state bit y[1]
);

    // Compute next-state bit y[1] based on current state y and input w
    // States: A=000, B=001, C=010, D=011, E=100, F=101
    // Next-state transitions determine next y1 bit:

    assign y1_next_out = 
        (y == 3'b001) ? 1'b1 :                      // B -> C or D: y1=1
        (y == 3'b010) ? (w ? 1'b1 : 1'b0) :         // C: w=1->D(y1=1), w=0->E(y1=0)
        (y == 3'b100) ? (w ? 1'b1 : 1'b0) :         // E: w=1->D(y1=1), w=0->E(y1=0)
        (y == 3'b101) ? 1'b1 :                      // F -> C or D: y1=1
        ( (y == 3'b000) || (y == 3'b011) ) ? 1'b0 : // A,D: y1=0
        1'b0;                                       // Default 0 for undefined states

    assign Y1 = y[1];

endmodule