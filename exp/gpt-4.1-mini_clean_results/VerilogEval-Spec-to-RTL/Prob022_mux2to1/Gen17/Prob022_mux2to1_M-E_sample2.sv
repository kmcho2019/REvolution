// TopModule: 1-bit 2-to-1 Multiplexer
// Gate-level implementation using NOT, AND, and OR gates

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire not_sel;
wire a_and_not_sel;
wire b_and_sel;

not u_not (not_sel, sel);
and u_and1 (a_and_not_sel, a, not_sel);
and u_and2 (b_and_sel, b, sel);
or  u_or   (out, a_and_not_sel, b_and_sel);

endmodule