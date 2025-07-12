module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Novel XNOR implementation using AND and OR gates
    assign out = (a & b) | (~a & ~b);

endmodule