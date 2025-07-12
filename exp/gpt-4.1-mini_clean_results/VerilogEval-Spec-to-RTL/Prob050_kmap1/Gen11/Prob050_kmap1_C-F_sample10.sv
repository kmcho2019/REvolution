module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire bc_or;
    wire n_b, n_c;
    wire and_term;

    assign n_b = ~b;
    assign n_c = ~c;
    assign bc_or = b | c;
    assign and_term = n_b & n_c & a;
    assign out = bc_or | and_term;

endmodule