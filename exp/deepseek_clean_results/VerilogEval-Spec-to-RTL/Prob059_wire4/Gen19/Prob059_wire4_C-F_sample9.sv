module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Input a connection
    assign w = a;
    
    // Input b connections (grouped for clarity)
    assign x = b;
    assign y = b;
    
    // Input c connection
    assign z = c;
endmodule