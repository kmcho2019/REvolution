module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // ab=00 => mux_in[0]: 0 1 1 1 at cd=00,01,11,10
    // mux_in[0] = c ? 1 : d;

    // ab=01 => mux_in[1]: all zero
    // mux_in[1] = 0;

    // ab=11 => mux_in[2]: 0 0 1 0 at cd=00,01,11,10
    // mux_in[2] = c ? d : 0;

    // ab=10 => mux_in[3]: 1 0 1 1 at cd=00,01,11,10
    // mux_in[3] = c ? 1 : (d ? 0 : 1);

    assign mux_in[0] = c ? 1'b1 : d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c ? d : 1'b0;
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);

endmodule