module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next y[1] logic as a combinational assign expression
    assign Y1 = 
        (~y2 & ~y1 &  y0) ? 1'b1 :        // B=001: next y1=1
        (~y2 &  y1 & ~y0) ? w     :        // C=010: next y1=w
        ( y2 & ~y1 & ~y0) ? w     :        // E=100: next y1=w
        ( y2 & ~y1 &  y0) ? 1'b1 :        // F=101: next y1=1
        1'b0;                              // other states: next y1=0

endmodule