module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

    // Direct wire assignments - optimal PPA
    assign w = a;
    assign x = b;
    assign y = b;  // b drives both x and y
    assign z = c;

endmodule