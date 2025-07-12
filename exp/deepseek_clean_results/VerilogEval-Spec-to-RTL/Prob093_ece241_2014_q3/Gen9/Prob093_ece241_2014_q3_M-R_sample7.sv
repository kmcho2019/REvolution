module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = 1 for cd=01,11,10 → c ? 1'b1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] is always 0 (K-map shows all 0s)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d (only 1 when both are 1)
    // Implement AND using mux: select d when c=1, else 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] = 1 for cd=00,11,10 → c ? d : ~d
    // ~d implemented via mux: select 1 when d=0, else 0
    assign mux_in[3] = c ? d : (d ? 1'b0 : 1'b1);

endmodule