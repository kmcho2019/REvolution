// TopModule: 1-bit 2-to-1 Multiplexer
// When sel=0, out = a; when sel=1, out = b.
// Implemented using always_comb and case statement for potential power optimization.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output reg  out
);

always @(*) begin
    case(sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 1'bx; // defensive coding, though sel is 1 bit
    endcase
end

endmodule