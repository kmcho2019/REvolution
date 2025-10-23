module TopModule (
    input a,
    input b,
    input c,
    output w = a,
    output x = b,
    output y = b,
    output z = c
);
    // No internal logic needed - connections are made in port declarations
endmodule