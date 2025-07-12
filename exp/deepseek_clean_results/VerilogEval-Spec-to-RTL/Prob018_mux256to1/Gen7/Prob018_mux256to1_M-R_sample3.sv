module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Calculate the selected 16-bit group directly from input
    wire [15:0] selected_group = in[(sel[7:4]*16)+15 : sel[7:4]*16];
    
    // Final selection within the group
    assign out = selected_group[sel[3:0]];

endmodule