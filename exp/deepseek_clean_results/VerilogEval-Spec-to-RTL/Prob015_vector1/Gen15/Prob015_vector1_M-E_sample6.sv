module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Implementation using shift and mask operations
    wire [15:0] shifted_hi = in >> 8;
    wire [15:0] shifted_lo = in << 8;
    
    assign out_hi = shifted_hi[7:0];
    assign out_lo = shifted_lo[15:8];

endmodule