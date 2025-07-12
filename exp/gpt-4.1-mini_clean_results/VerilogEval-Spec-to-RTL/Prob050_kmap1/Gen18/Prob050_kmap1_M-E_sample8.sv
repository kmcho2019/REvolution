// Basic gate modules
module Inv (
    input  in,
    output out
);
    assign out = ~in;
endmodule

module And3 (
    input  x,
    input  y,
    input  z,
    output q
);
    assign q = x & y & z;
endmodule

// TopModule implements the Karnaugh map function using structural gates:
// out = NOT( (NOT a) AND (NOT b) AND (NOT c) ) = a + b + c
module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire na, nb, nc;
    wire and_out;

    Inv inv_a(.in(a), .out(na));
    Inv inv_b(.in(b), .out(nb));
    Inv inv_c(.in(c), .out(nc));

    And3 and3_inst(.x(na), .y(nb), .z(nc), .q(and_out));

    Inv inv_out(.in(and_out), .out(out));
endmodule