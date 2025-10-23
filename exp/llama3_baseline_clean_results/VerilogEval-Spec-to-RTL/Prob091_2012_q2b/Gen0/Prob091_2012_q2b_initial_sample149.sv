module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    assign Y1 = y[1] & (w | ~w); // Y1 = 1 when current state is B
    assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & w); // Y3 = 1 when current state is B and next state is D, 
                                                         // or current state is C and next state is D, 
                                                         // or current state is D and next state is F

endmodule