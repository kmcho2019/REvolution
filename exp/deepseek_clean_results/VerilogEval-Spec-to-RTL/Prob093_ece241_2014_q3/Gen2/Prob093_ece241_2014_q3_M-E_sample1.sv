module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00: 1 when cd=00,01,11,10 (but not all)
    // Implement as ~c | d (but need to adjust for exact pattern)
    // Alternative: select between d (when c=1) and ~c (when c=0)
    assign mux_in[0] = c ? d : ~c;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: c & d
    assign mux_in[2] = c & d;

    // mux_in[3] for ab=10: 1 when cd=00,10,11
    // Implement as select between 1 (when d=0) and c (when d=1)
    assign mux_in[3] = d ? c : 1'b1;

endmodule