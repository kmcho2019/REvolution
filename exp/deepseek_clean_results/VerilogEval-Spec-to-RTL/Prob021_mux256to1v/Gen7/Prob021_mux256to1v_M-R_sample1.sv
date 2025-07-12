module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First select 64-bit chunk (16 possible chunks)
    wire [63:0] chunk = in[sel[7:4] * 64 +: 64];
    
    // Then select 4-bit group from the chunk (16 possible groups)
    assign out = chunk[sel[3:0] * 4 +: 4];

endmodule