module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Inputs: a,b select mux_in bit externally
    // mux_in[0] corresponds to ab=00 column in K-map:
    // cd: 00->0, 01->1, 11->1, 10->1
    // Expression from cd:
    // For d=0: c=0->0, c=1->1
    // For d=1: always 1
    // So mux_in[0] = d ? 1 : c
    assign mux_in[0] = d ? 1'b1 : c;

    // mux_in[1] for ab=01 column:
    // K-map column all zeros:
    // cd=00 0, 01 0, 11 0, 10 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11 column:
    // cd=00:0, 01:0, 11:1, 10:0
    // Expression: output = c & d
    // Implement as 2-to-1 mux:
    // if d=0 output 0; if d=1 output c
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3] for ab=10 column:
    // cd=00:1, 01:0, 11:1, 10:1
    // For d=0: output 1
    // For d=1: output c
    // So mux_in[3] = d ? c : 1
    assign mux_in[3] = d ? c : 1'b1;

endmodule