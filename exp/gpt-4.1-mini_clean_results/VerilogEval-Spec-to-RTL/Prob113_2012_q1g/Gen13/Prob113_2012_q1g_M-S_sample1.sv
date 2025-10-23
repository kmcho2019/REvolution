module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Simplified function from Karnaugh map grouping
assign f = 
    (~x2 & ~x3 & ~x1)   // Group covering top row corners (x2=0,x3=0,x1=0)
// | (x2 & ~x1) covers many 1s in rows where x2=1 and x1=0
  | (x2 & ~x1)
// | (x3 & x2 & x1) covers 1s in row 11 and columns 01,11 where x1=1 and x3=1,x2=1
  | (x3 & x2 & x1);

endmodule