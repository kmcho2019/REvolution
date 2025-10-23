// Simple 3-input OR gate module for clarity and modular design
module Or3Gate (
    input  x,
    input  y,
    input  z,
    output out
);
    assign out = x | y | z;
endmodule

// TopModule uses the Or3Gate to implement out = a | b | c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    Or3Gate or_gate_inst (
        .x(a),
        .y(b),
        .z(c),
        .out(out)
    );
endmodule