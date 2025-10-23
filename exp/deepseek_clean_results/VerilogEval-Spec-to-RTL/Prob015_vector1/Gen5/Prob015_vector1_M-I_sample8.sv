module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Explicitly show we're splitting into two 8-bit halves
    localparam BYTE_WIDTH = 8;
    
    assign out_hi = in[15:BYTE_WIDTH];
    assign out_lo = in[BYTE_WIDTH-1:0];

endmodule