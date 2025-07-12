module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire mux1_out;
    wire mux2_out;

    // Mux1: if c is 1 select b else select a
    assign mux1_out = c ? b : a;

    // Mux2: if a is 1 select d else select mux1_out
    assign mux2_out = a ? d : mux1_out;

    // Output q is high if either mux2_out or c is high
    // This expression reconstructs q = (a|b) & (c|d)
    assign q = mux2_out | c;

endmodule