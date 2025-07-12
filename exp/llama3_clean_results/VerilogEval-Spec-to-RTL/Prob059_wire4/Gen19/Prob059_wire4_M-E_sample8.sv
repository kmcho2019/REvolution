module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Use logical AND operation with a constant 1 to act as a buffer
    assign w = a & 1'b1;
    assign x = b & 1'b1;
    assign y = b & 1'b1;
    assign z = c & 1'b1;
endmodule