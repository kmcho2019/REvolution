module Inv1 (
    input wire a,
    output wire out
);
    assign out = ~a;
endmodule

module Nand2 (
    input wire a,
    input wire b,
    output wire out
);
    assign out = ~(a & b);
endmodule

module TopModule (
    input wire a,
    input wire b,
    output wire out
);
    wire not_a, not_b, nand_out;

    Inv1 inv_a(.a(a), .out(not_a));
    Inv1 inv_b(.a(b), .out(not_b));
    Nand2 nand_gate(.a(not_a), .b(not_b), .out(nand_out));

    assign out = ~nand_out;
endmodule