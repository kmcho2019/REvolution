module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Directly select the 16-bit group using upper 4 bits of sel (shifted by 4 bits)
    wire [15:0] selected_group = in[(sel[7:4] << 4) +: 16];
    
    // Select the specific bit using lower 4 bits of sel
    assign out = selected_group[sel[3:0]];

endmodule