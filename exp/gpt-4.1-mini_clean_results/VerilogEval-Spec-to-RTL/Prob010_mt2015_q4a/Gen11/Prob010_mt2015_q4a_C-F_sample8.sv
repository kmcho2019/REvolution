module XOR2 (
    input  a,
    input  b,
    output y
);
    // Use built-in xor primitive for gate-level clarity and optimization
    xor (y, a, b);
endmodule

module AND2 (
    input  a,
    input  b,
    output y
);
    // Use built-in and primitive for gate-level clarity and optimization
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