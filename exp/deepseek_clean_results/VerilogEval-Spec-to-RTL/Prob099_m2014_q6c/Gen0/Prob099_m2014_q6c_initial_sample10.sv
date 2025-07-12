module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is set when current state is A (y[0]=1) and w=0
    assign Y1 = ~w & y[0];

    // Y3 is set when:
    // (current state is B (y[1]=1) and w=1) OR
    // (current state is C (y[2]=1) and w=1) OR
    // (current state is E (y[4]=1) and w=1) OR
    // (current state is F (y[5]=1) and w=1)
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule