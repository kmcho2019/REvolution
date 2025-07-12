module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Select the appropriate 16-bit group using upper 4 bits of sel
    wire [15:0] selected_group = in[sel[7:4]*16 +: 16];
    
    // Select the final bit using lower 4 bits of sel
    assign out = selected_group[sel[3:0]];

endmodule