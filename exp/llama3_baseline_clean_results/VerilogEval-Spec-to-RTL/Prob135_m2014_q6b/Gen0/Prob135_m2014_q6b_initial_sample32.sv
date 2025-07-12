module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    // next-state logic for y[1]
    // since the problem only asks for next-state logic of y[1], 
    // the following equation represents the next state of y[1]
    // the next state of y[1] will be 1 if current state is B (001) and w is 1
    // or current state is D (100) and w is 1
    // or current state is F (101) and w is 1
    // or current state is A (000) and w is 0
    assign y[1] = (y == 3'b001 && w) || (y == 3'b100 && w) || (y == 3'b101 && w) || (y == 3'b000 && ~w);
endmodule