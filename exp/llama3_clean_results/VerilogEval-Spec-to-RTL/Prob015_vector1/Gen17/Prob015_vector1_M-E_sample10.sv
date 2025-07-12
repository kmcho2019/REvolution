// Define the TopModule with shift-and-mask approach
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    // Extract lower byte (no shift needed)
    assign out_lo = in[7:0];
    
    // Shift input right by 8 bits to align upper byte with lower bits
    // and apply mask to extract the upper byte
    assign out_hi = (in >> 8) & 8'hFF;
endmodule