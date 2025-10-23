module TopModule(
    input  a,
    input  b,
    output out
);

assign out = (a & b) | (~a & ~b); // Using AND and OR gates to implement the XNOR operation

endmodule