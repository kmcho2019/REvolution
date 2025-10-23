module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // State A is represented by y[0], State B by y[1], State C by y[2], 
    // State D by y[3], State E by y[4], and State F by y[5]

    // Y1 is the input of state flip-flop y[1], which is 1 when transitioning to B
    // This happens when in state A and w=1
    assign Y1 = y[0] & w;

    // Y3 is the input of state flip-flop y[3], which is 1 when transitioning to C
    // This happens when in state B and w=1 or in state F and w=1
    assign Y3 = (y[1] | y[5]) & w;

endmodule