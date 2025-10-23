module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] (ab=00): cd -> 00:0, 01:1, 11:1, 10:1
    // Implemented as: mux_in[0] = c ? 1 : d;
    assign mux_in[0] = c ? 1'b1 : (d ? 1'b1 : 1'b0);

    // mux_in[1] (ab=01): all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): cd -> 00:0, 01:0, 11:1, 10:0
    // Implemented as: mux_in[2] = c ? d : 0;
    assign mux_in[2] = c ? (d ? 1'b1 : 1'b0) : 1'b0;

    // mux_in[3] (ab=10): cd -> 00:1, 01:0, 11:1, 10:1
    // Implemented as: mux_in[3] = c ? 1 : ~d = c ? 1 : (d ? 0 : 1);
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);

endmodule