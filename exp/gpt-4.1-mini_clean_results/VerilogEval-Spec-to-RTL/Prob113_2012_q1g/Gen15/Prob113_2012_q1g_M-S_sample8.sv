module TopModule(
    input  [3:0] x,
    output       f
);

    // Direct minimal SOP expression derived from the K-map
    assign f = (~x[3] & ~x[2] & (~x[1] | ~x[0])) | (x[3] & x[2]) | (x[2] & ~x[1] & x[0]);

endmodule