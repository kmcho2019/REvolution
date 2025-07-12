module Or2 (
    input  x,
    input  y,
    output z
);
    assign z = x | y;
endmodule

module Mux2to1 (
    input  sel,
    input  d0,
    input  d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

// TopModule implements the K-map function using a mux and OR gate hierarchy
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire bc_or;

    Or2 or_gate (
        .x(b),
        .y(c),
        .z(bc_or)
    );

    Mux2to1 mux (
        .sel(a),
        .d0(bc_or),
        .d1(1'b1), // when a=1, output is 1
        .y(out)
    );
endmodule