module TopModule (
    input  wire a,    // Input bit a
    input  wire b,    // Input bit b
    input  wire sel,  // Select signal
    output wire out   // Output bit
);

// Gate-level implementation of 2-to-1 mux:
// out = (a AND ~sel) OR (b AND sel)
wire nsel;
wire a_and_nsel;
wire b_and_sel;

not u_not (nsel, sel);
and u_and1 (a_and_nsel, a, nsel);
and u_and2 (b_and_sel, b, sel);
or  u_or   (out, a_and_nsel, b_and_sel);

endmodule