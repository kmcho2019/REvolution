module TopModule(
    input [3:0] x,
    output f
);

    // Directly implement the simplified logic for f
    assign f = (x[2] & x[3]) | 
               (~x[2] & ~x[3] & (x[0] | ~x[0] & x[1]));

endmodule