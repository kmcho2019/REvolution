module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND results
    wire and_ab;
    wire and_cd;

    // Perform AND operations using continuous assignment
    assign and_ab = a & b;
    assign and_cd = c & d;

    // OR the intermediate AND results
    assign out = and_ab | and_cd;

    // Complement the output
    assign out_n = ~out;

endmodule