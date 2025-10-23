module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First level: 16 groups of 16 bits
    wire [15:0] group_out;
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_select
            // Only activate the selected group to save power
            wire group_enable = (sel[7:4] == i);
            wire [15:0] group_bits = in[(i*16)+15 : i*16] & {16{group_enable}};
            assign group_out = group_out | group_bits;
        end
    endgenerate

    // Second level: Select one bit from the active group
    assign out = group_out[sel[3:0]];

endmodule