module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire nb, nc;
    not nb_inst(nb, b);
    not nc_inst(nc, c);
    and and_inst(q_bar, nb, nc);
    not q_inst(q, q_bar);
endmodule