module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Superior XNOR implementation combining simplicity and efficiency
    assign out = (a == b)? 1'b1 : 1'b0;

    // Alternatively, for gate-level implementation enthusiasts:
    // assign out = (a & b) | (~a & ~b);

endmodule