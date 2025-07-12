module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Upper byte extraction using conceptual right shift
    assign out_hi = (in >> 8);

    // Lower byte extraction using masking
    assign out_lo = in & 8'hFF;

endmodule