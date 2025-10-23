// TopModule implements the K-map function as out = a | b | c using a direct assign statement
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    assign out = a | b | c;
endmodule