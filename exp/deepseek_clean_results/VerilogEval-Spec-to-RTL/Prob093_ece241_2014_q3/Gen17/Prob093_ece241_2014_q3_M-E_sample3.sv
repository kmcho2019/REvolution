module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] (ab=00): 0 when cd=00, else 1
    // Implemented with 2-to-1 mux: select=d, in0=c, in1=1
    wire mux0_out;
    assign mux0_out = d ? 1'b1 : c;
    assign mux_in[0] = mux0_out;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): 1 only when cd=11
    assign mux_in[2] = c & d;

    // mux_in[3] (ab=10): 1 when cd=00,10,11
    // Implemented with 2-to-1 mux: select=c, in0=~d, in1=1
    wire mux3_out;
    assign mux3_out = c ? 1'b1 : ~d;
    assign mux_in[3] = mux3_out;

endmodule