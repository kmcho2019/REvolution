module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Level 1: 4 groups of 64 bits (selected by sel[7:6])
    wire [63:0] level1_mux = 
        (sel[7:6] == 2'd0) ? in[63:0] :
        (sel[7:6] == 2'd1) ? in[127:64] :
        (sel[7:6] == 2'd2) ? in[191:128] :
                              in[255:192];

    // Level 2: 4 groups of 16 bits (selected by sel[5:4])
    wire [15:0] level2_mux = 
        (sel[5:4] == 2'd0) ? level1_mux[15:0] :
        (sel[5:4] == 2'd1) ? level1_mux[31:16] :
        (sel[5:4] == 2'd2) ? level1_mux[47:32] :
                              level1_mux[63:48];

    // Final selection (sel[3:0])
    assign out = level2_mux[sel[3:0]];

endmodule