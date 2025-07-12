module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0]: for ab=00 column
    // If c=0 output d, else 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: for ab=01 column, always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: for ab=11 column
    // If d=0 output 0, else c
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3]: for ab=10 column
    // If d=0 output 1, else c
    assign mux_in[3] = d ? c : 1'b1;

endmodule