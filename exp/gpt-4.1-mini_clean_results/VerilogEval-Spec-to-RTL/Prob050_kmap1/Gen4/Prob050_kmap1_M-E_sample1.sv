// Primitive NOT gate module
module Not1 (
    input  x,
    output z
);
    assign z = ~x;
endmodule

// Primitive 3-input NAND gate module
module Nand3 (
    input  x,
    input  y,
    input  w,
    output z
);
    assign z = ~(x & y & w);
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    wire na, nb, nc;

    // Invert inputs
    Not1 not_a(.x(a), .z(na));
    Not1 not_b(.x(b), .z(nb));
    Not1 not_c(.x(c), .z(nc));

    // NAND of inverted inputs produces output
    Nand3 nand3_inst (.x(na), .y(nb), .w(nc), .z(out));

endmodule