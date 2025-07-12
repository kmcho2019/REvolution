module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 0 when cd=00, else 1 (correct as originally implemented)
    assign mux_in[0] = c | d;

    // mux_in[1] (ab=01): always 0 (correct)
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 0 when c=0, 1 when c=1
    assign mux_in[2] = c;

    // mux_in[3] (ab=10): 0 when c≠d, 1 when c=d
    assign mux_in[3] = ~(c ^ d);

endmodule