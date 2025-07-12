module TopModule(
    input  [3:0] x,
    output       f
);

    // Directly implement conditions from the Karnaugh map
    // Simplify logic by minimizing the number of logical operations
    assign f = (x[2] & x[3]) | 
               (~x[2] & ~x[3] & (~x[0] | x[0] & ~x[1])) | 
               (x[2] & ~x[3] & (~x[0] | x[0] & ~x[1] | ~x[0] & x[1]));

endmodule