module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

wire nx0 = ~x0;
wire nx1 = ~x1;
wire nx3 = ~x3;
wire nx2 = ~x2;

// Terms based on minimized SOP from K-map
wire term1 = nx2 & nx3 & nx1;          // ~x2 & ~x3 & ~x1
wire term2 = x2 & nx0;                 // x2 & ~x0
wire term3 = x2 & nx3 & nx1;           // x2 & ~x3 & ~x1
wire term4 = x2 & x3 & x0 & x1;        // x2 & x3 & x0 & x1

assign f = term1 | term2 | term3 | term4;

endmodule