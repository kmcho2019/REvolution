module TopModule(y, w, Y2, Y4);
    input [5:0] y;
    input w;
    output Y2;
    output Y4;

    // Derive next-state signals Y2 and Y4 by inspection
    assign Y2 = (y[0] && w) || (y[4] && w) || (y[5] && w); // Y2
    assign Y4 = (y[1] && ~w) || (y[2] && w) || (y[4] && ~w); // Y4

endmodule