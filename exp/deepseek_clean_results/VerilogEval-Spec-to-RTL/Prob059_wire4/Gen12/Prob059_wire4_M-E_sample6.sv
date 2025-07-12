module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Mux-based implementation where select lines are hardwired
    // to always choose the correct input (functionally equivalent to wires)
    
    // w = a
    assign w = (1'b0) ? b : a;  // Select line hardwired to choose 'a'
    
    // x = b
    assign x = (1'b0) ? c : b;  // Select line hardwired to choose 'b'
    
    // y = b
    assign y = (1'b1) ? b : a;  // Select line hardwired to choose 'b'
    
    // z = c
    assign z = (1'b1) ? c : b;  // Select line hardwired to choose 'c'
endmodule