module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Upper byte: simple bit selection (no need for masking after shift)
    assign out_hi = in[15:8];
    
    // Lower byte: direct bit selection (more efficient than masking)
    assign out_lo = in[7:0];

endmodule