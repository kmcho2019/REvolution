module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0]: corresponds to ab=00 column of K-map
    // Outputs: cd=00->0, 01->1, 11->1, 10->1
    // Implement as 2-to-1 mux with c as select:
    // if c=0 output d, else 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: corresponds to ab=01 column of K-map
    // Always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: corresponds to ab=11 column
    // Outputs: cd=00->0, 01->0, 11->1, 10->0
    // Implement as 2-to-1 mux with d as select:
    // if d=0 output 0, else c
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3]: corresponds to ab=10 column
    // Outputs: cd=00->1, 01->0, 11->1, 10->1
    // Implement as 2-to-1 mux with d as select:
    // if d=0 output 1, else c
    assign mux_in[3] = d ? c : 1'b1;

endmodule