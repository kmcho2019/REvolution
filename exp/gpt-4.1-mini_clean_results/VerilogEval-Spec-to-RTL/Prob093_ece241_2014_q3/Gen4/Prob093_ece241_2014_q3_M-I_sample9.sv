module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0]: corresponds to ab=00 column of K-map
    // K-map outputs for cd=00,01,11,10: 0,1,1,1
    // Implement as: if c=1 output 1, else output d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: corresponds to ab=01 column, all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2]: corresponds to ab=11 column
    // K-map outputs: 0,0,1,0 for cd=00,01,11,10
    // Implement as: if d=1 output c, else 0
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3]: corresponds to ab=10 column
    // K-map outputs: 1,0,1,1 for cd=00,01,11,10
    // Implement as: if d=0 output 1, else output c
    assign mux_in[3] = d ? c : 1'b1;

endmodule