module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Select the appropriate 16-bit chunk based on sel[7:4]
    wire [15:0] selected_chunk = in[sel[7:4]*16 +: 16];
    
    // Select the final bit from the chunk using sel[3:0]
    assign out = selected_chunk[sel[3:0]];

endmodule