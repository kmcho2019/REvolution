module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct vector output assignment
    assign outv = vec;
    
    // Direct bit assignments - most efficient implementation
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule