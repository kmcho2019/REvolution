module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // First level: Select one of 16 64-bit chunks using upper 4 bits of sel
    wire [63:0] chunk = in[sel[7:4]*64 +: 64];
    
    // Second level: Select one of 16 4-bit outputs within the chunk using lower 4 bits
    assign out = chunk[sel[3:0]*4 +: 4];
endmodule