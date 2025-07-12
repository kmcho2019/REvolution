module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Split into 8 slices of 32 bits each
    wire [31:0] slice [7:0];
    
    assign slice[0] = in[31:0];
    assign slice[1] = in[63:32];
    assign slice[2] = in[95:64];
    assign slice[3] = in[127:96];
    assign slice[4] = in[159:128];
    assign slice[5] = in[191:160];
    assign slice[6] = in[223:192];
    assign slice[7] = in[255:224];
    
    // First stage: select 32-bit slice using upper 3 bits of sel
    wire [31:0] selected_slice;
    assign selected_slice = slice[sel[7:5]];
    
    // Second stage: select 1 bit from slice using lower 5 bits of sel
    assign out = selected_slice[sel[4:0]];

endmodule