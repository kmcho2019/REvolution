module TopModule(
    input  [3:0] x,
    output       f
);

// Explicitly assign signals consistent with Karnaugh map indexing
// Rows indexed by x[2]x[3], cols by x[0]x[1], but logic expression uses direct bits

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Complemented signals for clarity and reuse
wire nx3 = ~x3;
wire nx1 = ~x1;
wire nx0 = ~x0;

// Fused minimal expression:
// f = (~x3 & ~x1) | (x2 & ~x0) | (x2 & x3 & x0 & x1)

assign f = (nx3 & nx1)
        | (x2 & nx0)
        | (x2 & x3 & x0 & x1);

endmodule