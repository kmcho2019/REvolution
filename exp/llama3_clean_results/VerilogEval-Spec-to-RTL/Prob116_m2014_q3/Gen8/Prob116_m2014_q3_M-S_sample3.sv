module TopModule(
    input [3:0] x,
    output f
);

// Directly implement the logic derived from the Karnaugh map
assign f = (x[3] & (x[1] | x[2])) | (~x[3] & x[1] & x[2]);

endmodule