// Or3Gate performs 3-input OR operation
module Or3Gate (
    input  x,
    input  y,
    input  z,
    output out
);
    assign out = x | y | z;
endmodule

// TopModule uses only the Or3Gate module to implement out = a OR b OR c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    Or3Gate or_gate (
        .x(a),
        .y(b),
        .z(c),
        .out(out)
    );
endmodule