module TopModule(
    input [3:0] x,
    output logic f
);
    
    assign f = (x[3] & (x[1] | x[2])) | (x[0] & x[1] & x[2] & ~x[3]);

    // Alternatively, considering the conditions more explicitly:
    // assign f = ((x[3] & (x[1] | x[2])) | (x[0] & x[1] & x[2] & ~x[3]));
    // This logic directly implements the conditions observed from the Karnaugh map.

endmodule