// 1-bit NOT gate module
module Not1 (
    input  in,
    output out
);
    assign out = ~in;
endmodule

// 3-input AND gate module
module And3 (
    input  x,
    input  y,
    input  z,
    output q
);
    assign q = x & y & z;
endmodule

// 1-bit NAND gate module
module Nand1 (
    input  in1,
    input  in2,
    output out
);
    assign out = ~(in1 & in2);
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire na, nb, nc;
    wire and_out;

    // Invert inputs
    Not1 not_a (.in(a), .out(na));
    Not1 not_b (.in(b), .out(nb));
    Not1 not_c (.in(c), .out(nc));

    // AND the inverted inputs
    And3 and3_inv (.x(na), .y(nb), .z(nc), .q(and_out));

    // Invert the AND output to get out
    Not1 not_out (.in(and_out), .out(out));

endmodule