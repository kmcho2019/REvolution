module TopModule(
    input  [3:0] x,
    output       f
);

// f = (!x[2] & !x[1]) | (x[3] & !x[1]) | (x[2] & x[1] & !x[0])
assign f = ((!x[2]) & (!x[1])) | (x[3] & (!x[1])) | (x[2] & x[1] & (!x[0]));

endmodule