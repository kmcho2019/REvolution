module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Next-state logic for Y2 (y[1])
    // State B is next when A is current and w=0, or when D is current and w=1
    assign Y2 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & ~w) | (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w);

    // Next-state logic for Y4 (y[3])
    // State D is next when B is current and w=1, or when C or E is current and w=1, or when D is current and w=1
    assign Y4 = (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & w) | (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) | (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w) | (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w);

    // Y1 and Y3 are directly taken from y[0] and y[2] as per the state encoding
    assign Y1 = y[0];
    assign Y3 = y[2];
endmodule