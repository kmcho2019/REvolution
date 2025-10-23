module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    assign mux_in[0] = c | d;      // ab=00
    assign mux_in[1] = ~c & d;     // ab=01
    assign mux_in[2] = c;          // ab=11
    assign mux_in[3] = c | ~d;     // ab=10

endmodule