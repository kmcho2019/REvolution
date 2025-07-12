// TopModule: 1-bit 2-to-1 Multiplexer
// When sel=0, out = a; when sel=1, out = b.
// Implemented using a combinational always block.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output reg  out
);

always @(*) begin
    if (sel)
        out = b;
    else
        out = a;
end

endmodule