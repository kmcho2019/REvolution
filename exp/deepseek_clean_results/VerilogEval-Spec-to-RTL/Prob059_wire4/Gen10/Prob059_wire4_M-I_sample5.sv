module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Explicit individual wire assignments
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;
endmodule