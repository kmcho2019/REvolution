module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Since A is 000001, B is 000010, C is 000100, D is 001000, E is 010000, and F is 100000
    // Y1 corresponds to the next state being B
    assign Y1 = (y[0] && w); // Next state is B when current state is A and w is 1

    // Y3 corresponds to the next state being D
    assign Y3 = ((y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[3] && !w));
    // Next state is D when current state is B and w is 0, or current state is C and w is 0, 
    // or current state is E and w is 0, or current state is D and w is 0
endmodule