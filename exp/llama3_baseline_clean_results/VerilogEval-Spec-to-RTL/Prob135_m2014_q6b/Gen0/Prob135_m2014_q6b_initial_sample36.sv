module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    wire y0, y1, y2;
    assign y0 = y[0];
    assign y1 = y[1];
    assign y2 = y[2];

    // State A (000)
    // Next state is B (001) if w = 0, stay in A (000) if w = 1
    // y1 remains 0 in both cases

    // State B (001)
    // Next state is C (010) if w = 0, go to D (011) if w = 1
    // y1 becomes 1 if w = 0, y1 becomes 1 if w = 1

    // State C (010)
    // Next state is E (100) if w = 0, go to D (011) if w = 1
    // y1 becomes 1 if w = 0, y1 becomes 1 if w = 1

    // State D (011)
    // Next state is F (101) if w = 0, go to A (000) if w = 1
    // y1 becomes 1 if w = 0, y1 becomes 0 if w = 1

    // State E (100)
    // Next state is E (100) if w = 0, go to D (011) if w = 1
    // y1 remains 0 if w = 0, y1 becomes 1 if w = 1

    // State F (101)
    // Next state is C (010) if w = 0, go to D (011) if w = 1
    // y1 becomes 1 if w = 0, y1 becomes 1 if w = 1

    assign Y1 = (y2 && !w) || 
               (y1 && (y0 || w)) || 
               (!y2 && !y1 && w && !y0);

endmodule