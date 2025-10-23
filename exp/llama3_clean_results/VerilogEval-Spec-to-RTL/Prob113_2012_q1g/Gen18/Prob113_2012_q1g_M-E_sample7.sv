module TopModule(
    input  [3:0] x,
    output       f
);

    wire f_00, f_11;

    // Circuit for x[2] and x[3] both 0
    assign f_00 = (~x[0] & ~x[1]) | (x[0] & ~x[1]) | (~x[0] & x[1]);

    // Circuit for x[2] and x[3] both 1
    assign f_11 = (~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1]);

    // Mux to select between f_00 and f_11 based on x[2] and x[3]
    assign f = (~x[2] & ~x[3] & f_00) | (x[2] & x[3] & f_11) | (x[2] & ~x[3] & ((~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1])) | (~x[2] & x[3] & ((~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & x[1])));

endmodule