module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // NOT d implemented as a 2-to-1 mux (no logic gate)
    wire not_d = d ? 1'b0 : 1'b1;

    // mux_in[0]: ab=00 column (cd=00:0,01:1,11:1,10:1)
    // Implement as mux with selector c, then selector d:
    // When c=0: if d=0 => 0, else 1
    // When c=1: output 1 regardless of d
    assign mux_in[0] = c ? 1'b1 : (d ? 1'b1 : 1'b0);

    // mux_in[1]: ab=01 column (all zeros)
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 column (cd=00:0,01:0,11:1,10:0)
    // Implement as mux with selector c, then d:
    // If c=0: always 0
    // If c=1: output d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3]: ab=10 column (cd=00:1,01:0,11:1,10:1)
    // Implement as mux with selector c, then d:
    // If c=0: output not_d
    // If c=1: output 1
    assign mux_in[3] = c ? 1'b1 : not_d;

endmodule