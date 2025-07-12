module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] (ab=00):
    // c=0 => 0
    // c=1 => ~d  (implemented as d ? 0 : 1)
    assign mux_in[0] = c ? (d ? 1'b0 : 1'b1) : 1'b0;

    // mux_in[1] (ab=01): all zero
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11):
    // c=0 => 0
    // c=1 => d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] (ab=10):
    // c=0 => ~d (d ? 0 :1)
    // c=1 => 1
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);

endmodule