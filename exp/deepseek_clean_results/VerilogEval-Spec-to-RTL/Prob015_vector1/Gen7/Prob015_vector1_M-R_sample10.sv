module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Split 16-bit word into [upper_byte, lower_byte]
    assign {out_hi, out_lo} = in;

endmodule