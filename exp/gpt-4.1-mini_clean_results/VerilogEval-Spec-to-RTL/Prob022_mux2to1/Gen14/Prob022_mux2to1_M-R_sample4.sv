// TopModule: 1-bit 2-to-1 Multiplexer using always_comb procedural block
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output reg  out
);

always @(*) begin
    if (sel == 1'b0) begin
        out = a;
    end else begin
        out = b;
    end
end

endmodule