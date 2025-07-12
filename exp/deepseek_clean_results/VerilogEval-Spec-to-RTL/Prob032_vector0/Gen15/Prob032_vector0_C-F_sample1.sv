module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct vector mirroring (optimal for PPA)
    assign outv = vec;
    
    // Clear bit-position mapping with consistent syntax
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule