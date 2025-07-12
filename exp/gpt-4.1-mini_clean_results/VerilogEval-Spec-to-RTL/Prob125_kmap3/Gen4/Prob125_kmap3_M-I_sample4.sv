module TopModule (
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, unused in logic
    output out
);

wire a_buf = a;
wire b_buf = b;
wire c_buf = c;

// The output is high if 'a' is high, or if 'c' is high and 'b' is low.
// The input 'd' is don't-care and ignored to simplify logic.
assign out = a_buf | (c_buf & ~b_buf);

endmodule