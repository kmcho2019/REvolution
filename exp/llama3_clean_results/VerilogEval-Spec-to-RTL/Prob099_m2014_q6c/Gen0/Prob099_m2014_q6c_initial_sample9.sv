module TopModule(y, w, Y1, Y3);
    input [5:0] y;
    input w;
    output Y1;
    output Y3;

    // Derive next-state signals Y2 and Y4 by inspection
    assign Y1 = (y[0] && w) || (y[4] && w) || (y[5] && w); // Y2
    assign Y3 = (y[1] && ~w) || (y[2] && w) || (y[4] && ~w); // Y4

endmodule