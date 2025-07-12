module TopModule(
    input  [3:0] x,
    output       f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Complement signals
wire nx3 = ~x3;
wire nx1 = ~x1;
wire nx0 = ~x0;

// Decompose the four-input AND term: (~x3 & x2 & x1 & ~x0)
wire and_mid1 = nx3 & x2;     // (~x3 & x2)
wire and_mid2 = x1 & nx0;    // (x1 & ~x0)
wire and_mid = and_mid1 & and_mid2; // combined 4-input AND

// Decompose the (x1 & x0) term inside the last big OR
wire and_high = x1 & x0;

// Combine inside the last term: (x3 & x2 & (~x0 | (x1 & x0)))
// Compute inner OR: (~x0 | (x1 & x0))
wire or_inner = nx0 | and_high;
// Compute (x3 & x2)
wire and_high1 = x3 & x2;
// Final term
wire last_term = and_high1 & or_inner;

// Final expression:
assign f = (nx3 & nx1)
        | and_mid
        | last_term;

endmodule