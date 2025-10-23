module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Treat input as two concatenated bytes and slice them
    wire [15:0] in_padded = in;
    assign {out_hi, out_lo} = in_padded;

endmodule