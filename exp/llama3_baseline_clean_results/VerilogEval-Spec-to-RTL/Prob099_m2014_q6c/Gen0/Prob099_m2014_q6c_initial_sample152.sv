module TopModule(y, w, Y1, Y3, Y2, Y4);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;
    output Y2;
    output Y4;

    assign Y1 = y[0];
    assign Y3 = y[2];

    assign Y2 = (y[0] && w); // next state is B when current state is A and input w is 1

    assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && ~w) || (y[5] && w); 
    // next state is D when current state is B and input w is 1, or current state is C and input w is 1, 
    // or current state is E and input w is 0, or current state is F and input w is 1
endmodule