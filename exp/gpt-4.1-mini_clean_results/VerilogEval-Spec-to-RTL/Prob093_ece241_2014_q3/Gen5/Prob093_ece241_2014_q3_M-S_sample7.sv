module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // For ab=00: mux_in[0] = c OR d (1 when c=1 or d=1)
    assign mux_in[0] = c | d;

    // For ab=01: mux_in[1] = 0 (always)
    assign mux_in[1] = 1'b0;

    // For ab=11: mux_in[2] = c AND d
    assign mux_in[2] = c & d;

    // For ab=10: mux_in[3] = (~d) OR (c AND d)
    assign mux_in[3] = (~d) | (c & d);

endmodule