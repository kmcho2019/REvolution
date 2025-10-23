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
    wire and_ab;
    wire and_cd;

    // Perform AND operations directly with continuous assignments
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Perform OR operation directly with continuous assignment
    assign out = and_ab | and_cd;

    // Instantiate NOT gate module for output inversion
    NotGate inv1 (.y(out_n), .x(out));

endmodule