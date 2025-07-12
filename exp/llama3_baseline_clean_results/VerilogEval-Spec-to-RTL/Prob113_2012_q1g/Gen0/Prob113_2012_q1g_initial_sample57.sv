module TopModule(
    input [3:0] x,
    output f
);

assign f = (x[2] & x[3] & x[0]) | 
           (x[2] & x[3] & ~x[1]) | 
           (~x[2] & ~x[3] & x[0] & ~x[1]) | 
           (~x[2] & x[3] & x[0] & ~x[1]) | 
           (x[2] & ~x[3] & x[0] & x[1]) | 
           (x[2] & ~x[3] & ~x[0] & x[1]);

// An alternative and simpler implementation after analyzing the Karnaugh map
// assign f = (x[2] & (x[0] | x[1])) | (x[0] & ~x[1] & (~x[2] & ~x[3] | x[2] & ~x[3]));

// An even more optimized version based on K-map simplification
assign f = (x[2] & x[0]) | (x[2] & x[1]) | (~x[2] & ~x[3] & x[0] & ~x[1]) | (x[2] & ~x[3] & x[0]);

// But looking closely at the K-map again, it simplifies further
assign f = (x[2] & (x[0] | x[1])) | (x[0] & ~x[1] & ~x[3]);

endmodule