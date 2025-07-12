module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: 0 when cd=00, 1 otherwise
    // Implemented as: if d=0, check c (0 when c=0, 1 when c=1)
    //                if d=1, always 1
    assign mux_in[0] = d ? 1'b1 : c;

    // ab=01: always 0
    assign mux_in[1] = 1'b0;

    // ab=11: 1 only when cd=11
    assign mux_in[2] = c & d;

    // ab=10: 0 when cd=01, 1 otherwise
    // Implemented as: when c=0, output is 1 (cd=00,10)
    //                when c=1, output is d (0 when d=0, 1 when d=1)
    assign mux_in[3] = c ? d : 1'b1;

endmodule