module Equality4 (
    input  [3:0] in,
    input  [3:0] const_val,
    output       eq
);
    // Compare 4-bit input with constant value
    assign eq = (in == const_val);
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [3:0] inputs = {a,b,c,d};

    // Equality checks for decimal 2, 7, and 15
    wire eq_2  = (inputs == 4'd2);
    wire eq_7  = (inputs == 4'd7);
    wire eq_15 = (inputs == 4'd15);

    // SOP output: OR of equality signals
    assign out_sop = eq_2 | eq_7 | eq_15;

    // Minimal POS expression for out_pos considering don't-cares:
    // zeros = 0,1,4,5,6,9,10,13,14
    // don't-cares = 3,8,11,12 (ignored in logic)
    // Minimal POS derived:
    // out_pos = (a + c + d) & (b + c + ~d) & (~a + ~b + ~c + d)

    assign out_pos = (a | c | d) & (b | c | ~d) & (~a | ~b | ~c | d);

endmodule