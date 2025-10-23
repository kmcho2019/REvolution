module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Directly assign inputs to outputs
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;
endmodule