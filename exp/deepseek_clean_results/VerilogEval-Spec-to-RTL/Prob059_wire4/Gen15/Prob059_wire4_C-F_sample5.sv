module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Input a routing
    assign w = a;
    
    // Input b routing (duplicated to two outputs)
    assign x = b;
    assign y = b;
    
    // Input c routing
    assign z = c;
endmodule