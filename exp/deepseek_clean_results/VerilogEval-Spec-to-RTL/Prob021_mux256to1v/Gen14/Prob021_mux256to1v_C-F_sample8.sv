module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct hierarchical selection with optimized wiring
    wire [3:0] group_out;
    
    // First level: Select one of 16 groups (each 64 bits)
    // Second level: Select one of 16 4-bit inputs within group
    assign group_out = in[(sel[7:4]*64 + sel[3:0]*4) +: 4];
    
    // Final output assignment
    assign out = group_out;

endmodule