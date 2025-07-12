module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (a'b' & (c'd' | c'd)) | 
             (a'b & c'd') | 
             (a'b' & cd) | 
             (a' & b & c'd') | 
             (a & b & (c'd' | c'd | c'd));

// However, simplifying the logic based on observation:
assign out = (a'b' & (c'd' | c'd | cd)) | 
             (a & b & (c'd' | c'd | cd));

endmodule