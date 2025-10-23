module TopModule(
    input [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 per K-map labels
    output f
);
    assign f = (x[3] & ~(x[2] & ~x[0] & x[1])) |  // Rows 11/10 cases
               (~x[3] & x[2] & x[0] & x[1]);       // Row 01, column 11 case
endmodule