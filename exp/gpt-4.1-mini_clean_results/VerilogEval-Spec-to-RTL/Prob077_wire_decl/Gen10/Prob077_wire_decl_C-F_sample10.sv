module AndGate(output y, input x1, input x2);
    and (y, x1, x2);
endmodule

module OrGate(output y, input x1, input x2);
    or (y, x1, x2);
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_out1, and_out2;

AndGate and_inst1 (.y(and_out1), .x1(a), .x2(b));
AndGate and_inst2 (.y(and_out2), .x1(c), .x2(d));

OrGate or_inst (.y(out), .x1(and_out1), .x2(and_out2));

not not_inst (out_n, out);

endmodule