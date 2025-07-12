module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    assign Y1 = ~w & y[0];  // Next state is B when current state is A and w is 0
    assign Y3 = (~w & y[1]) | (~w & y[2]) | (~w & y[4]) | (~w & y[5]); 
    // Next state is D when current state is B and w is 0, or C and w is 0, or E and w is 0, or F and w is 0
endmodule