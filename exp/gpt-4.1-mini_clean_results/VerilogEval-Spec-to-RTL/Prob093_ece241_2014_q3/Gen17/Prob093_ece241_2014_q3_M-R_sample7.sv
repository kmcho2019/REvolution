module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0]: K-map column ab=00 => cd=00:0,01:1,11:1,10:1
    // Using nested mux: mux_in[0] = c ? (d ? 1 : 1) : (d ? 1 : 0);
    // Simplify inside: c=0: d?1:0 ; c=1: always 1
    assign mux_in[0] = c ? (d ? 1'b1 : 1'b1) : (d ? 1'b1 : 1'b0);

    // mux_in[1]: ab=01 => all zeros
    assign mux_in[1] = c ? (d ? 1'b0 : 1'b0) : (d ? 1'b0 : 1'b0);

    // mux_in[2]: ab=11 => cd=00:0,01:0,11:1,10:0
    // nested mux: c ? (d ? 1 : 0) : (d ? 0 : 0)
    assign mux_in[2] = c ? (d ? 1'b1 : 1'b0) : (d ? 1'b0 : 1'b0);

    // mux_in[3]: ab=10 => cd=00:1,01:0,11:1,10:1
    // nested mux: c ? (d ? 1 : 1) : (d ? 0 : 1)
    assign mux_in[3] = c ? (d ? 1'b1 : 1'b1) : (d ? 1'b0 : 1'b1);

endmodule