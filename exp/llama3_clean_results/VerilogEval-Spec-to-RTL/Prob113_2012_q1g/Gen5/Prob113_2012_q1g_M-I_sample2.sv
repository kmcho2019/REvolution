module TopModule(
    input [3:0] x,
    output f
);

    assign f = (x[2] & ~(x[3] & x[0] & x[1])) | // When x[2] is 1, f is 1 unless x[3], x[0], and x[1] are all 1
               (~x[2] & ~x[3] & (x[0] ^ x[1])); // When x[2] is 0, f is 1 if x[3] is 0 and x[0] or x[1] (but not both) is 1

endmodule