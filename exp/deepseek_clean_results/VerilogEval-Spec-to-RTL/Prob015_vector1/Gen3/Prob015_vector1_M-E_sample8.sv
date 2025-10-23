module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Conceptual implementation using shift and mask operations
    assign out_lo = in & 8'hFF;          // Mask lower byte
    assign out_hi = (in >> 8) & 8'hFF;   // Shift then mask upper byte

endmodule