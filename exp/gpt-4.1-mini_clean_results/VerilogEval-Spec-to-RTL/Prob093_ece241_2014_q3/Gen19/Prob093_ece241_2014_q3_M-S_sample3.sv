module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // ab=00 -> mux_in[0]:
    // if c=0 output d else 1
    assign mux_in[0] = c ? 1'b1 : d;

    // ab=01 -> mux_in[1]: always 0
    assign mux_in[1] = 1'b0;

    // ab=11 -> mux_in[2]:
    // if c=0 output 0 else d
    assign mux_in[2] = c ? d : 1'b0;

    // ab=10 -> mux_in[3]:
    // if d=0 output 1 else c
    assign mux_in[3] = d ? c : 1'b1;

endmodule