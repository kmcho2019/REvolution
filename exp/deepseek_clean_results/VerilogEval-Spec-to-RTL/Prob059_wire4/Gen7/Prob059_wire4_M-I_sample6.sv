module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wire assignments for optimal PPA
    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;
endmodule