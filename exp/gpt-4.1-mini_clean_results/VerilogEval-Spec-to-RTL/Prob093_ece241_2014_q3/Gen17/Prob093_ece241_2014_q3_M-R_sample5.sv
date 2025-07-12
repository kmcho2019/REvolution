module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Implement mux_in[0] for ab=00:
    // K-map: output=1 only when c=1 and d=0
    // mux_in[0] = c ? (~d) : 1'b0
    assign mux_in[0] = c ? (~d) : 1'b0;

    // Implement mux_in[1] for ab=01:
    // output=1 only when c=0 and d=0
    // mux_in[1] = ~c & ~d
    assign mux_in[1] = (~c) & (~d);

    // Implement mux_in[2] for ab=11:
    // output=1 only when c=1 and d=1
    assign mux_in[2] = c & d;

    // Implement mux_in[3] for ab=10:
    // output=1 except when c=0 and d=1
    // mux_in[3] = (~d) | c
    assign mux_in[3] = (~d) | c;
endmodule