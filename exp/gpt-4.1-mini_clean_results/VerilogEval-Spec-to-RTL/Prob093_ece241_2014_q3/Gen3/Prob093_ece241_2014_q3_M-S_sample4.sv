module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0]: ab=00 column from K-map: 0 1 1 1 for cd=00 01 11 10
    // Implement as c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: ab=01 column always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 column: 0 0 1 0
    // Implement as c & d
    assign mux_in[2] = c & d;

    // mux_in[3]: ab=10 column: 1 0 1 1
    // Implement as c | (~d) using mux behavior
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);

endmodule