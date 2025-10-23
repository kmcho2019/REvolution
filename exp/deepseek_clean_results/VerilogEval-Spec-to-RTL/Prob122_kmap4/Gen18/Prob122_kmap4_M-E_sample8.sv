module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Convert inputs to Gray code and compare specific patterns
    assign out = (b ^ (a & ~b)) ^ (d ^ (c & ~d));

endmodule