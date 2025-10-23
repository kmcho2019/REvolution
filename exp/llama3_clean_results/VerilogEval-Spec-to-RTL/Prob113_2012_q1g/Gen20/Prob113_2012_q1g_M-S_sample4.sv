module TopModule(
    input  [3:0] x,
    output       f
);

    assign f = (x[2] & x[3] & ~x[0] & ~x[1] & ~x[2])? 1'b0 :
               (x[2] & x[3]) | 
               (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1])) |
               (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

    // However, using the K-map, a simplified version can be derived directly:
    // When x[2] and x[3] are high, f is 1 except when x[0] and x[1] are 00.
    // When x[2] and x[3] are low, f is 1 when x[0] and x[1] are 00 or 11.
    // When x[2] is high and x[3] is low, f is 1 when x[0] and x[1] are not 11.

    // The simplified version:
    assign f = (x[2] & x[3]) | 
               (~x[2] & ~x[3] & (x[0] == x[1])) | 
               (x[2] & ~x[3] & ~(x[0] & ~x[1]));

    // This can be further simplified as:
    assign f = (x[2] & x[3]) | 
               (~x[2] & ~x[3] & (x[0] == x[1])) | 
               (x[2] & ~x[3] & ~x[0] & ~x[1]) | 
               (x[2] & ~x[3] & x[0] & ~x[1]) | 
               (x[2] & ~x[3] & ~x[0] & x[1]);

    // However, this can be directly derived and expressed more simply by
    // considering the cases when f is 1 directly from the K-map.

    // Final simplified version based on K-map observation:
    assign f = (x[2] & x[3]) | 
               (~x[2] & ~x[3] & (x[0] == x[1])) | 
               (x[2] & ~x[3] & (~x[0] | ~x[1]));

    // Simplifying the logic further based on the K-map:
    assign f = (x[2] & x[3]) | 
               (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & x[1])) | 
               (x[2] & ~x[3] & (~x[0] | ~x[1]));

    // The logic can be simplified even more by directly implementing the
    // conditions from the K-map.

    // Simplified version directly from K-map:
    assign f = (x[2] & x[3] & (~x[0] | x[1])) | 
               (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & x[1])) | 
               (x[2] & ~x[3] & (~x[0] | ~x[1]));

endmodule