module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Level 1: Select 64-bit chunk (sel[7:6])
    wire [63:0] level1_out;
    assign level1_out = in[64*(sel[7:6]+1)-1 : 64*sel[7:6]];

    // Level 2: Select 16-bit chunk (sel[5:4])
    wire [15:0] level2_out;
    assign level2_out = level1_out[16*(sel[5:4]+1)-1 : 16*sel[5:4]];

    // Final selection (sel[3:0])
    assign out = level2_out[sel[3:0]];

endmodule