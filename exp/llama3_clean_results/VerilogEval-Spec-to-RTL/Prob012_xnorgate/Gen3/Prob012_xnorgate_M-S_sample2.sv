module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Using equality operator to implement XNOR
    assign out = (a == b);

endmodule