module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Directly assigning inputs to outputs within TopModule for simplicity and efficiency
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;
endmodule