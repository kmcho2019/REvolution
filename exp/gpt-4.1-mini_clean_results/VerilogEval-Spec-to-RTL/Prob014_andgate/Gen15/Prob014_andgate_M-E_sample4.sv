module Buffer1 (
    input wire in,
    output wire out
);
    assign out = in;
endmodule

module Nand2 (
    input wire a,
    input wire b,
    output wire out
);
    assign out = ~(a & b);
endmodule

module Inv1 (
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
    wire a_buf, b_buf, nand_out;

    Buffer1 bufA(.in(a), .out(a_buf));
    Buffer1 bufB(.in(b), .out(b_buf));
    Nand2 nand_gate(.a(a_buf), .b(b_buf), .out(nand_out));
    Inv1 inverter(.in(nand_out), .out(out));
endmodule