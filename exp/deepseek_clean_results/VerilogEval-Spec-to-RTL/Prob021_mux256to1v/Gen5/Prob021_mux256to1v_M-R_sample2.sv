module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // First level: Select one of 16 groups (each 64 bits = 16×4)
    wire [63:0] selected_group = in[sel[7:4] * 64 +: 64];
    
    // Second level: Select one 4-bit value from the group
    assign out = selected_group[sel[3:0] * 4 +: 4];
endmodule