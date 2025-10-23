module XOR2 (
    input  a,
    input  b,
    output y
);
    // Use built-in xor primitive directly for efficiency and clarity
    xor (y, a, b);
endmodule

module AND2 (
    input  a,
    input  b,
    output y
);
    // Use built-in and primitive directly for efficiency and clarity
    and (y, a, b);
endmodule

module TopModule (
    input  x,
    input  y,
    output z
);
    wire xor_out;

    XOR2 u_xor (
        .a(x),
        .b(y),
        .y(xor_out)
    );

    AND2 u_and (
        .a(xor_out),
        .b(x),
        .y(z)
    );
endmodule