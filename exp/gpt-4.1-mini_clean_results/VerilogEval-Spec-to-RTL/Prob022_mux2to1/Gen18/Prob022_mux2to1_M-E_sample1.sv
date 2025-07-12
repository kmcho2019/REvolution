// TopModule: 1-bit 2-to-1 Multiplexer using gate-level structural modeling
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire sel_n;
wire a_and_seln;
wire b_and_sel;

// Invert sel
not u_not_sel (sel_n, sel);

// AND gates for inputs
and u_and_a (a_and_seln, a, sel_n);
and u_and_b (b_and_sel, b, sel);

// OR gate to select output
or  u_or_out (out, a_and_seln, b_and_sel);

endmodule