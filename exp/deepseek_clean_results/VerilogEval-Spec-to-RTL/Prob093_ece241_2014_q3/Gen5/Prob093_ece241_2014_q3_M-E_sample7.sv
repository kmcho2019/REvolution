module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00: matches d (1 for cd=01,11,10)
    assign mux_in[0] = d;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: c & d
    assign mux_in[2] = c & d;

    // mux_in[3] for ab=10: ~d | c
    // Implement with 2-to-1 mux: select 1 when c=1, else ~d
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule