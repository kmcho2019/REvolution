// TopModule: 1-bit 2-to-1 Multiplexer using a procedural always block
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output reg  out
);

always @(*) begin
    if (sel == 1'b0)
        out = a;
    else
        out = b;
end

endmodule