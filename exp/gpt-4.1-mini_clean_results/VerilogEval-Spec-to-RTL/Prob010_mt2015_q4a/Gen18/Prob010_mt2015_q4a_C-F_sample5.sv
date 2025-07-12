// Reusable 2-input gate modules defined with built-in primitives for clarity and modularity
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

// TopModule implements z = (x ^ y) & x using direct continuous assignment for best PPA
module TopModule (
    input  x,
    input  y,
    output z
);
    // Direct continuous assignment provides optimal synthesis results,
    // minimal power, area, and timing overhead compared to module instantiation.
    assign z = (x ^ y) & x;

    /*
    // Optional modular instantiation for clarity or reuse:
    // wire xor_out;
    // XOR2 u_xor (.a(x), .b(y), .y(xor_out));
    // AND2 u_and (.a(xor_out), .b(x), .y(z));
    */
endmodule