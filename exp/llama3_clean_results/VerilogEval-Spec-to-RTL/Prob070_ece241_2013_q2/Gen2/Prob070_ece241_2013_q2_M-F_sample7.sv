module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (!a && b && !c && !d) || 
                 (!a && b && c && d) || 
                 (a && b && c && d);

// Minimum Product-of-Sums (POS) form for out_pos
// Directly considering the conditions for a logic-1 output
assign out_pos = (a || !a && b) && (b || !b && (c && d)) && (c || !c && (b && d)) && (d || !d && (b && c));

// Alternative approach to derive POS from SOP
// Since the given problem involves specific decimal numbers,
// we could simplify the POS form by analyzing the K-map or applying Boolean algebra principles.

endmodule