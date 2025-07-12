module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 
    // When c=0: if d=0 output 0 else 1
    // When c=1: output 1
    // Implemented as c selected 2-to-1 mux, with d selected 2-to-1 mux inside
    assign mux_in[0] = c ? 1'b1 : (d ? 1'b1 : 1'b0);

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11):
    // When c=0: output 0
    // When c=1: if d=0 output 0 else 1
    assign mux_in[2] = c ? (d ? 1'b1 : 1'b0) : 1'b0;

    // mux_in[3] (ab=10):
    // When c=0: if d=0 output 1 else 0
    // When c=1: always 1
    assign mux_in[3] = c ? (d ? 1'b1 : 1'b1) : (d ? 1'b0 : 1'b1);

endmodule