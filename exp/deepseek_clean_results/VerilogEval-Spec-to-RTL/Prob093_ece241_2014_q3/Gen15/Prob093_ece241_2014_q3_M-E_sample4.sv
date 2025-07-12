module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] for ab=00
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01
    assign mux_in[1] = ~c & d;

    // mux_in[2] for ab=11
    assign mux_in[2] = c;

    // mux_in[3] for ab=10
    assign mux_in[3] = d ? ~c : 1'b1;

endmodule