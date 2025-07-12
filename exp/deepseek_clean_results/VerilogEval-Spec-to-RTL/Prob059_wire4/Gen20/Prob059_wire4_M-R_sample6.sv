module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // All connections as direct assign statements
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;
endmodule