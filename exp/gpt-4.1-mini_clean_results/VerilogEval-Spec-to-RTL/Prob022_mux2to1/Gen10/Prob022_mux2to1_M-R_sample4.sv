module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output reg  out
);

// One-bit 2-to-1 multiplexer using always_comb block
// When sel=0, out = a; when sel=1, out = b
always @(*) begin
    if (sel == 1'b0)
        out = a;
    else
        out = b;
end

endmodule