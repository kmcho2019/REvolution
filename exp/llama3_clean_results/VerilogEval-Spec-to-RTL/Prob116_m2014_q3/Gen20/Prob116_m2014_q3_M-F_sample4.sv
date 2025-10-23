module TopModule(
    input [3:0] x,
    output logic f
);

    // Corrected logic equation directly translating Karnaugh map conditions
    assign f = (x[3]) | (~x[3] & ~x[1] & x[2]);

endmodule