module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR using individual gates
    or or0(out_or_bitwise[0], a[0], b[0]);
    or or1(out_or_bitwise[1], a[1], b[1]);
    or or2(out_or_bitwise[2], a[2], b[2]);

    // Logical OR implementation
    wire a_any, b_any;
    or or_a(a_any, a[0], a[1], a[2]);
    or or_b(b_any, b[0], b[1], b[2]);
    or or_final(out_or_logical, a_any, b_any);

    // NOT operations with explicit bit ordering
    not not_b0(out_not[5], b[2]);
    not not_b1(out_not[4], b[1]);
    not not_b2(out_not[3], b[0]);
    not not_a0(out_not[2], a[2]);
    not not_a1(out_not[1], a[1]);
    not not_a2(out_not[0], a[0]);

endmodule