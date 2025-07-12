module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Calculate group start index and select the 16-bit group
    wire [15:0] selected_group = in[(sel[7:4]*16)+15 : sel[7:4]*16];
    
    // Final bit selection within the group
    assign out = selected_group[sel[3:0]];

endmodule