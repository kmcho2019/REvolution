module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // For ab=00 (mux_in[0]):
    // cd: 00->0, 01->1, 11->1, 10->1
    // Analyze c and d:
    // For c=0 (cd=00 or 01): output 0 (d=0) or 1 (d=1) => output = d
    // For c=1 (cd=10 or 11): both 1
    // So: mux_in[0] = c ? 1 : d;

    // For ab=01 (mux_in[1]): all zeros
    // mux_in[1] = 0;

    // For ab=11 (mux_in[2]):
    // cd: 00->0, 01->0, 11->1, 10->0
    // For c=0: 0
    // For c=1: d
    // mux_in[2] = c ? d : 0;

    // For ab=10 (mux_in[3]):
    // cd: 00->1, 01->0, 11->1, 10->1
    // For c=0: d=0->1, d=1->0 => ~d
    // For c=1: 1
    // mux_in[3] = c ? 1 : ~d;

    assign mux_in[0] = c ? 1'b1 : d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c ? d : 1'b0;
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule