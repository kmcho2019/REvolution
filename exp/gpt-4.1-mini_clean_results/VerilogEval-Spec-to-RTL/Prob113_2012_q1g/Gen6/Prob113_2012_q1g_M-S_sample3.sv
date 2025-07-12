module TopModule(
    input  [3:0] x,
    output       f
);

// Assign bits for clarity
wire x0 = x[0];
wire x1 = x[1];
wire x2 = x[2];
wire x3 = x[3];

// Simplified expression derived from Karnaugh map:
// f = (~x2 & ~x3 & (~x0 | x1)) | (x2 & x3) | (x2 & ~x3 & ~x1)
assign f = (~x2 & ~x3 & (~x0 | x1)) | (x2 & x3) | (x2 & ~x3 & ~x1);

endmodule