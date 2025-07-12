module NotGate (
    output y,
    input  x
);
    not (y, x);
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires holding AND results
    wire and1_res = a & b;
    wire and2_res = c & d;

    // OR of the two AND results as output
    assign out = and1_res | and2_res;

    // Inverted output through explicit NOT gate instantiation
    NotGate not1 (.y(out_n), .x(out));

endmodule