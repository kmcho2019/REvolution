module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Bit 0 selection
    assign out[0] = in[sel*4 + 0];
    
    // Bit 1 selection
    assign out[1] = in[sel*4 + 1];
    
    // Bit 2 selection
    assign out[2] = in[sel*4 + 2];
    
    // Bit 3 selection
    assign out[3] = in[sel*4 + 3];

endmodule