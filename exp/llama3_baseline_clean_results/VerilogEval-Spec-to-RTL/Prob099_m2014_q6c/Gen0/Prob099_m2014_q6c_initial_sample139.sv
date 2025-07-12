module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // y[0] is set for state A (000001) with w = 0
    assign Y1 = ~w & y[0];

    // y[2] is set for state C (000100) with w = 0
    assign Y3 = ~w & y[2];
endmodule