module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

    // Simple wire connections:
    assign w = a;  // a -> w
    assign x = b;  // b -> x
    assign y = b;  // b -> y
    assign z = c;  // c -> z

endmodule