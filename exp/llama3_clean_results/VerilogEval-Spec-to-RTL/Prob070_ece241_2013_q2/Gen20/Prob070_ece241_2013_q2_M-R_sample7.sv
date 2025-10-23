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
assign sop_expr = (a == 0 && b == 1 && c == 0 && d == 0) || 
                  (a == 0 && b == 1 && c == 1 && d == 1) || 
                  (a == 1 && b == 1 && c == 1 && d == 1);

// Minimum product-of-sums form
assign pos_expr = (a || b) && (b || c || d);

// Assign SOP and POS expressions to output ports
assign out_sop = sop_expr;
assign out_pos = pos_expr;

endmodule