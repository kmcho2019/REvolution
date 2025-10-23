// Define primitive 2-input OR gate module
module Or2 (
    input  x,
    input  y,
    output z
);
    assign z = x | y;
endmodule

// Define primitive 3-input OR gate using two 2-input ORs
module Or3 (
    input  x,
    input  y,
    input  w,
    output z
);
    wire t;
    Or2 or1 (.x(x), .y(y), .z(t));
    Or2 or2 (.x(t), .y(w), .z(z));
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Instantiate 3-input OR gate using Or3 module
    Or3 u_or3 (
        .x(a),
        .y(b),
        .w(c),
        .z(out)
    );

endmodule