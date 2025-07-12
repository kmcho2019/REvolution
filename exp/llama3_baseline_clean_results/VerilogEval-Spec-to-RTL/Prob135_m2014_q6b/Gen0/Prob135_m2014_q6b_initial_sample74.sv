module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    // Next-state logic for y[1]
    // We only care about the cases where y[1] is 1 in the next state
    // This occurs when the current state is B (001), D (100), E (101), or F (110)
    // and the input w is 1, or when the current state is C (011) and the input w is 0
    // Since y[1] is the most significant bit of the state code, it is 1 in the next state
    // when the current state is D (100), E (101), or F (110)
    // or when the current state is B (001) and the input w is 1
    // or when the current state is C (011) and the input w is 0
    wire next_y1;
    assign next_y1 = (y == 3'b001 && w) || (y == 3'b011 && ~w) || (y == 3'b100) || (y == 3'b101) || (y == 3'b110);
endmodule