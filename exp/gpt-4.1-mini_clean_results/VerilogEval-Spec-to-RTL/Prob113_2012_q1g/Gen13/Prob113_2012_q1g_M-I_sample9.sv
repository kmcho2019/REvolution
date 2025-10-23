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

// Intermediate signals
wire temp_and = x3 & x1 & x0;  // 3-input AND
wire or_inner = nx0 | temp_and; // OR of ~x0 and temp_and

assign f = (nx3 & nx1)    // (~x3 & ~x1)
        | (x2 & or_inner); // x2 & (~x0 | (x3 & x1 & x0))

endmodule