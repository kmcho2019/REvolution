module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire next_y1;

    assign next_y1 = 
        (~y[2] & ~y[1] &  y[0])             // state B (001)
      | ((~y[2] &  y[1] & ~y[0]) & w)      // state C (010) with w=1
      | (( y[2] & ~y[1] & ~y[0]) & w)      // state E (100) with w=1
      | ( y[2] & ~y[1] &  y[0]);           // state F (101)

    assign Y1 = next_y1;

endmodule