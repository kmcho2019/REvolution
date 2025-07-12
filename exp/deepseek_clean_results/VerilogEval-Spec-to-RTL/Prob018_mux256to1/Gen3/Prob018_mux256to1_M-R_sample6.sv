module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Select the appropriate 16-bit group based on sel[7:4]
    wire [15:0] selected_group = in[(sel[7:4]*16)+15 : sel[7:4]*16];
    
    // Select the bit within the group using sel[3:0]
    assign out = selected_group[sel[3:0]];

endmodule