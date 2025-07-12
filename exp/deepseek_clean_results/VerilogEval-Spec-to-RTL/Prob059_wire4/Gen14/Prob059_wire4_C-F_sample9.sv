module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Single input to single output connections
    assign w = a;
    assign z = c;
    
    // b drives both x and y outputs
    assign x = b;
    assign y = b;
endmodule