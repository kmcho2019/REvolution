module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First level: 16 groups of 16 bits
    wire [15:0] group_select [15:0];
    
    // Split input into 16 groups
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_split
            assign group_select[i] = in[(i*16)+15 : i*16];
        end
    endgenerate
    
    // Second level: select within group
    wire [15:0] selected_group = group_select[sel[7:4]];
    
    // Final selection
    assign out = selected_group[sel[3:0]];

endmodule