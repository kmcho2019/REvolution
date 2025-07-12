module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

assign f = 
    (~x1 & ~x0)             // covers rows where x1=0,x0=0 (covers many 1s)
  | ( x2 &  x3 &  x1)      // covers some 1s in bottom-right block
  | ( x2 & ~x3 & ~x0)      // covers 1s in row x2=1, x3=0, x0=0
  | (~x3 & ~x2 & x1 & ~x0) // covers single 1 at top row col 10 (x3=0,x2=0,x1=1,x0=0)
  ;

endmodule