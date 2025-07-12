module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0]: for ab=00, values: 0 1 1 1 (cd=00,01,11,10)
    // Implemented as c?1:d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: for ab=01, all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2]: for ab=11, values: 0 0 1 0 (cd=00,01,11,10)
    // Implemented as c?d:0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3]: for ab=10, values: 1 0 1 1 (cd=00,01,11,10)
    // Implemented as c?1:~d
    assign mux_in[3] = c ? 1'b1 : ~d;
endmodule