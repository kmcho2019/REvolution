module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Input a connections
    assign w = a;
    
    // Input b connections
    assign x = b;
    assign y = b;
    
    // Input c connections
    assign z = c;
endmodule