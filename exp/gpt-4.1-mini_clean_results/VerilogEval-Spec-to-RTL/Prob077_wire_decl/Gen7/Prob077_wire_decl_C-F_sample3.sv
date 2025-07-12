module AndGate (output y, input x1, input x2);
    and U_and (y, x1, x2);
endmodule

module OrGate (output y, input x1, input x2);
    or U_or (y, x1, x2);
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_ab, and_cd;

AndGate and1 (.y(and_ab), .x1(a), .x2(b));
AndGate and2 (.y(and_cd), .x1(c), .x2(d));

OrGate or1 (.y(out), .x1(and_ab), .x2(and_cd));

not U_not (out_n, out);

endmodule