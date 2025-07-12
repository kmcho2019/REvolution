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

    // Assign intermediate wires via dataflow
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Instantiate OR gate using intermediate wires
    or u_or(out, and_ab, and_cd);

    // Generate inverted output using continuous assignment
    assign out_n = ~out;

endmodule