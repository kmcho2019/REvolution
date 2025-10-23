module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    wire [7:0] out_hi = in[15:8];
    wire [7:0] out_lo = in[7:0];

endmodule