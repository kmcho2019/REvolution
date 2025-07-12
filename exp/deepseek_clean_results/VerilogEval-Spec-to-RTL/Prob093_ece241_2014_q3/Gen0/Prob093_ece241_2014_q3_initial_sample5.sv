module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] implementation: when ab=00
    // K-map shows output is 1 when cd=01,11,10
    // Implemented as: c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] implementation: when ab=01
    // Always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] implementation: when ab=11
    // Output is 1 only when cd=11
    // Implemented as c AND d using mux
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3] implementation: when ab=10
    // Output is 1 when cd=00,11,10
    // Implemented as: c ? d : 1'b1
    assign mux_in[3] = c ? d : 1'b1;

endmodule