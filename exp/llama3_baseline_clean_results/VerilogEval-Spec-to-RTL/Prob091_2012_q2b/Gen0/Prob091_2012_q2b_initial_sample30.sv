module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Y1 corresponds to state flip-flop y[1], which is set to 1 when the next state is B (000010)
    assign Y1 = (~w) & y[0]; // A (000001) and w = 0

    // Y3 corresponds to state flip-flop y[3], which is set to 1 when the next state is D (001000)
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]) | (w & y[3]); 
endmodule