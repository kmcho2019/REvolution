module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    wire y0, y1, y2;
    assign y0 = y[0];
    assign y1 = y[1];
    assign y2 = y[2];

    assign Y1 = ~(y0 & y1 & ~y2 & ~w) & ~(y0 & ~y1 & y2 & w) & 
               ~(~y0 & y1 & y2 & w) & ~(~y0 & ~y1 & ~y2 & ~w) & 
               ~(y0 & ~y1 & ~y2 & w);
endmodule