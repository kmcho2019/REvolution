module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Explicit individual assignments for clarity
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;
endmodule