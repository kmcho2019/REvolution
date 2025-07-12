module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Output is high if any input is high.
    // This directly implements the K-map where out=0 only for a=0,b=0,c=0.
    assign out = a | b | c;
endmodule