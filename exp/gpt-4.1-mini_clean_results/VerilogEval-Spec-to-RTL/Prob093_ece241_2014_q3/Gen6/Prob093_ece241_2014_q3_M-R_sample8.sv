module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // Implement mux_in[0] for ab=00 column: cd=00:0, 01:1, 11:1, 10:1
    // Use a 2-to-1 mux on c, select by d:
    // When d=0: if c=0 =>0, c=1 =>1
    // When d=1: always 1
    // So mux_in[0] = d ? 1 : c
    assign mux_in[0] = d ? 1'b1 : c;

    // mux_in[1] for ab=01 column: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11 column: cd=00:0, 01:0, 11:1, 10:0
    // This matches c AND d
    // Use a 2-to-1 mux: 
    // When d=0: output 0
    // When d=1: output c
    assign mux_in[2] = d ? c : 1'b0;

    // mux_in[3] for ab=10 column: cd=00:1, 01:0, 11:1, 10:1
    // Observe:
    // For d=0: output =1 (both c=0 or 1)
    // For d=1: output = c
    // So mux_in[3] = d ? c : 1
    assign mux_in[3] = d ? c : 1'b1;

endmodule