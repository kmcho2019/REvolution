module TopModule (
    input  [15:0] in,       // 16-bit input word
    output [7:0]  out_hi,   // Upper byte [15:8]
    output [7:0]  out_lo    // Lower byte [7:0]
);

    // Single assignment using concatenation
    assign {out_hi, out_lo} = in;

endmodule