// TopModule: 1-bit 2-to-1 Multiplexer using basic gates
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire nsel;      // inverted sel
wire and0_out;  // output of first AND gate
wire and1_out;  // output of second AND gate

// Invert sel
not u_not_sel(nsel, sel);

// AND gates for each input with select signals
and u_and0(and0_out, a, nsel);
and u_and1(and1_out, b, sel);

// OR gate to combine results
or u_or_out(out, and0_out, and1_out);

endmodule