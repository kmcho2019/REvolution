module TopModule (
    input  a, b, c, d,
    output q
);
    // Novel implementation with conditional behavior:
    // - When a=0: normal OR operation (b|c)
    // - When a=1: requires both b and c to be 1
    // - d acts as override signal
    assign q = ((~a & (b | c)) | (a & b & c) | d;
endmodule