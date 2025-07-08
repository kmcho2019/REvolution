module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

assign f = ( ~x3 & x2 )         // 0 1 x
        | (  x3 & ~x2 & x1 )   // 1 0 1
        | (  x3 & x2 & x1 );   // 1 1 1

endmodule