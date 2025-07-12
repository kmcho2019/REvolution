module TopModule(
    input [3:0] x,
    output logic f
);

    // Simplified logic equation based on the essential conditions
    assign f = (x[3] & (x[1] | x[2])) | (~x[3] & ~x[0] & x[1]);

endmodule