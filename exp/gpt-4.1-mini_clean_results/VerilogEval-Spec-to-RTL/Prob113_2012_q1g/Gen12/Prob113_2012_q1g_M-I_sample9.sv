module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Complemented signals
wire nx3 = ~x3;
wire nx1 = ~x1;
wire nx0 = ~x0;

// Intermediate signals to break down the 4-input AND
wire and_high1 = x2 & x3;
wire and_high2 = x0 & x1;
wire and_high = and_high1 & and_high2;

assign f = (nx3 & nx1)
        | (x2 & nx0)
        | and_high;

endmodule