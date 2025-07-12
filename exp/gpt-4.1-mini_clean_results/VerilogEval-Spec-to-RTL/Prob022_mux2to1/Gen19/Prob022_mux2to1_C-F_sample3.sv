// TopModule: 1-bit 2-to-1 Multiplexer
// Implements a combinational multiplexer using always_comb procedural block
// with an internal reg and a continuous assignment to the wire output.
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

reg out_reg;

always @(*) begin
    if (sel)
        out_reg = b;
    else
        out_reg = a;
end

assign out = out_reg;

endmodule