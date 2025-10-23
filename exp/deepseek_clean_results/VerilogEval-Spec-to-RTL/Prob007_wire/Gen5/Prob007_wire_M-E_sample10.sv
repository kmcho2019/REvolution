module TopModule (
    input in,
    output out
);
    // Implement using a pass transistor with permanent control
    tranif1 mytran(out, in, 1'b1);
endmodule