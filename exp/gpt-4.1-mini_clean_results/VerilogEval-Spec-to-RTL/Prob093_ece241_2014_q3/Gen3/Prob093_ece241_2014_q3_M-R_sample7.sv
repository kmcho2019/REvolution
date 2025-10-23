module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Compute NOT d using conditional operator (2-to-1 mux):
    wire not_d = d ? 1'b0 : 1'b1;

    // ab=00 column (mux_in[0]):
    // K-map: 0 1 1 1 for cd=00 01 11 10
    // function: c + d
    assign mux_in[0] = c ? 1'b1 : d;

    // ab=01 column (mux_in[1]):
    // all zeros
    assign mux_in[1] = 1'b0;

    // ab=11 column (mux_in[2]):
    // K-map: 0 0 1 0 for cd=00 01 11 10
    // function: c & d
    assign mux_in[2] = c ? d : 1'b0;

    // ab=10 column (mux_in[3]):
    // K-map: 1 0 1 1 for cd=00 01 11 10
    // function: c + ~d
    assign mux_in[3] = c ? 1'b1 : not_d;

endmodule