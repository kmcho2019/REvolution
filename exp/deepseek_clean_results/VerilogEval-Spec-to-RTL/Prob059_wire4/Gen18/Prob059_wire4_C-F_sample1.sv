module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Direct input to output connections
    assign w = a;
    assign z = c;
    
    // Duplicate b to both x and y outputs
    assign x = b;
    assign y = b;
endmodule