module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Simplified XNOR implementation using equality operator
    assign out = (a == b)? 1'b1 : 1'b0;

endmodule