module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Upper byte direct selection
    assign out_hi = in[15:8];
    
    // Lower byte direct selection
    assign out_lo = in[7:0];

endmodule