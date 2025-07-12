module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Intermediate variables to hold the results of sub-expressions
wire ab_00, ab_01, ab_10, ab_11;
assign ab_00 = ~a & ~b;
assign ab_01 = ~a & b;
assign ab_10 = a & ~b;
assign ab_11 = a & b;

wire cd_00, cd_01, cd_10, cd_11;
assign cd_00 = ~c & ~d;
assign cd_01 = ~c & d;
assign cd_10 = c & ~d;
assign cd_11 = c & d;

// Implementing the Karnaugh map using the intermediate variables
assign out = (cd_00 & (ab_00 | ab_01 | ab_10)) | 
             (cd_01 & (ab_00 | ab_10)) | 
             (cd_11 & (ab_01 | ab_10 | ab_11));

endmodule