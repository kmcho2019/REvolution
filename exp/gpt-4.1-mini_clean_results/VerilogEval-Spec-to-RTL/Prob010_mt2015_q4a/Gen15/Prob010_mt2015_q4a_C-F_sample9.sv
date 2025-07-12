// Parameterized 2-input gate modules using built-in primitives for reuse and clarity
module XOR2 (
    input  a,
    input  b,
    output y
);
    xor (y, a, b);
endmodule

module AND2 (
    input  a,
    input  b,
    output y
);
    and (y, a, b);
endmodule

// TopModule directly implements z = (x ^ y) & x with optional gate module instantiation
module TopModule (
    input  x,
    input  y,
    output z
);
    // Option 1 (Recommended for best PPA): direct continuous assignment
    assign z = (x ^ y) & x;

    /*
    // Option 2: use instantiated XOR2 and AND2 modules to preserve modularity
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
    */
endmodule