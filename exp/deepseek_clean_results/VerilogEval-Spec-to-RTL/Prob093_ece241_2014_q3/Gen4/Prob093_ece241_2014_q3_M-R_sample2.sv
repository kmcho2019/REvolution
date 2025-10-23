module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00: 1 when cd=01,11,10
    // Implement as select between 1 (when c=1) and d (when c=0)
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: c & d
    assign mux_in[2] = c & d;

    // mux_in[3] for ab=10: 1 when cd=00,10,11
    // Implement as select between 1 (when c=1) and ~d (when c=0)
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule