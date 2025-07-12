module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define wires for SOP and POS expressions
wire sop_expr, pos_expr;

// Minimum sum-of-products form
assign sop_expr = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form
assign pos_expr = (a | b) & (b | c | d);

// Assign SOP and POS expressions to output ports
assign out_sop = sop_expr;
assign out_pos = pos_expr;

endmodule