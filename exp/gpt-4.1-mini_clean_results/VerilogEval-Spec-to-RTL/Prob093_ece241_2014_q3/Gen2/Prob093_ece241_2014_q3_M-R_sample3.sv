module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Invert d by mux behavior: not_d = (d == 0) ? 1 : 0
    wire not_d = d ? 1'b0 : 1'b1;

    // mux_in[0]: corresponds to ab=00 column in K-map:
    // cd=00->0, 01->1, 11->1, 10->1
    // Implement as c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: corresponds to ab=01 column, always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: corresponds to ab=11 column
    // cd=00->0,01->0,11->1,10->0
    // Implement as c ? d : 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3]: corresponds to ab=10 column
    // cd=00->1,01->0,11->1,10->1
    // Implement as c ? 1 : not_d
    assign mux_in[3] = c ? 1'b1 : not_d;

endmodule