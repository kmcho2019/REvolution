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

module TopModule (
    input  x,
    input  y,
    output z
);
    // Inline the logic directly with a continuous assignment for optimal PPA
    assign z = (x ^ y) & x;
endmodule