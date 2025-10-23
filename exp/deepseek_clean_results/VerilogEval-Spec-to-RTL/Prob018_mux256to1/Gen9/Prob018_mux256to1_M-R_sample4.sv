module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Select the 16-bit group using upper 4 bits of sel
    wire [15:0] selected_group = in[(sel[7:4]*16)+15 : sel[7:4]*16];
    
    // Select the specific bit within the group using lower 4 bits
    assign out = selected_group[sel[3:0]];

endmodule