module TopModule(
    input  in,
    output out
);
    
    // Direct and minimal implementation of a NOT gate
    assign out = ~in;
    
endmodule