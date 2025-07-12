module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

wire nx3 = ~x3;
wire nx1 = ~x1;
wire nx0 = ~x0;

assign f = (nx3 & nx1)      // covers both ~x2 & ~x3 & ~x1 and x2 & ~x3 & ~x1
        | (x2 & nx0)        // x2 & ~x0
        | (x2 & x3 & x0 & x1); // x2 & x3 & x0 & x1

endmodule