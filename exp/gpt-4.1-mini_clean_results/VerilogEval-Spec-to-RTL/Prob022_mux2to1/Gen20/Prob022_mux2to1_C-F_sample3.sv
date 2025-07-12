// TopModule: 1-bit 2-to-1 Multiplexer combining behavioral and structural clarity
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire sel_n = ~sel;
wire a_selected = a & sel_n;
wire b_selected = b & sel;

// Behavioral continuous assignment using the selected signals
assign out = a_selected | b_selected;

endmodule