module NOTGate(
    input in,
    output out
);
    assign out = ~in;
endmodule

module NANDGate(
    input in1,
    input in2,
    output out
);
    assign out = ~(in1 & in2);
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);
    wire not_a, not_b;

    NOTGate not_gate_a (.in(a), .out(not_a));
    NOTGate not_gate_b (.in(b), .out(not_b));
    NANDGate nand_gate (.in1(not_a), .in2(not_b), .out(out));
endmodule