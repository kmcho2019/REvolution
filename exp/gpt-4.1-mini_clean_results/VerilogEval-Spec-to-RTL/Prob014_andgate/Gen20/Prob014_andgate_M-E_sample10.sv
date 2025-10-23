module Nor2 (
    input wire a,
    input wire b,
    output wire out
);
    assign out = ~(a | b);
endmodule

module Inv (
    input wire in,
    output wire out
);
    assign out = ~in;
endmodule

module TopModule (
    input wire a,
    input wire b,
    output wire out
);
    wire not_a, not_b;

    // Invert inputs
    Inv inv_a(.in(a), .out(not_a));
    Inv inv_b(.in(b), .out(not_b));

    // NOR gate on inverted inputs yields AND of original inputs
    Nor2 nor_gate(.a(not_a), .b(not_b), .out(out));
endmodule