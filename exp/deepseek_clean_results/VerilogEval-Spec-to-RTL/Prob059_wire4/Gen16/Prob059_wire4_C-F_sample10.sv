module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wire connections for maximum efficiency
    assign w = a;
    assign z = c;
    
    // Duplicate b connection using explicit assigns
    assign x = b;
    assign y = b;
endmodule