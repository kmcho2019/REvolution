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
    // Intermediate wires for AND gate results
    wire and_ab;
    wire and_cd;

    // Continuous assignments for the AND gates
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Continuous assignment for OR gate output
    assign out = and_ab | and_cd;

    // Explicit NOT gate instance for out_n
    NotGate inv_out_n (.y(out_n), .x(out));

endmodule