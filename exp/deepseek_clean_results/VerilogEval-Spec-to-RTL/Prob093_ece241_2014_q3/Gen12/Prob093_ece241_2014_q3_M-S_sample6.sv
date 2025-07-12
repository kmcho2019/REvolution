module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 0 when cd=00, else 1
    assign mux_in[0] = c | d;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 0 only when cd=01
    assign mux_in[2] = ~(~c & d);

    // mux_in[3] (ab=10): same as mux_in[0]
    assign mux_in[3] = mux_in[0];

endmodule