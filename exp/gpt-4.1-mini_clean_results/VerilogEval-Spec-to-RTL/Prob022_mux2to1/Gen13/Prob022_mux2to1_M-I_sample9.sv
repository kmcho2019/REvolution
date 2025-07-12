// TopModule: 1-bit 2-to-1 Multiplexer using structural logic
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire nsel;
wire and0_out;
wire and1_out;

assign nsel = ~sel;
assign and0_out = nsel & a;
assign and1_out = sel & b;
assign out = and0_out | and1_out;

endmodule