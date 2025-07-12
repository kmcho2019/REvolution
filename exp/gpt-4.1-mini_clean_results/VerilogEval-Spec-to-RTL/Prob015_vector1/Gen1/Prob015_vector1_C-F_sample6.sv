// TopModule: Splits a 16-bit input into two 8-bit outputs.
// out_hi contains bits [15:8] (upper byte)
// out_lo contains bits [7:0] (lower byte)
// Purely combinational logic via continuous assignments.
module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule