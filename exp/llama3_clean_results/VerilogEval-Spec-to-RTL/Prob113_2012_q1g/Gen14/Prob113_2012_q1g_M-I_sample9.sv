module TopModule(
    input [3:0] x,
    output f
);

    assign f = ((~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1])) | 
                (x[2] & x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1])) | 
                (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1])));

    // Alternatively, the expression can be further simplified by factoring out common terms
    // assign f = ((~x[2] & ~x[3]) | x[2] & x[3] | (x[2] & ~x[3])) & 
    //            ((~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]));

endmodule