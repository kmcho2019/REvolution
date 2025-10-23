module TopModule(
    input [3:0] x,
    output logic f
);

    // Corrected logic equation based on the Karnaugh map
    assign f = (x[3] & (x[1] | x[2])) | (x[3] & x[2]);

endmodule