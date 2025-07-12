module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Internal wires for mux outputs
    wire mux0_out, mux3_out;

    // mux_in[0] (ab=00): 0,1,1,0 for cd=00,01,11,10
    // When c=1: pass d, when c=0: pass d&~c (which is 0 except cd=01)
    assign mux0_out = c ? d : (d & ~c);
    assign mux_in[0] = mux0_out;

    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): c AND d
    assign mux_in[2] = c & d;

    // mux_in[3] (ab=10): 1 for cd=00,10,11 (0 for 01)
    // When d=0: pass 1, when d=1: pass c
    assign mux3_out = d ? c : 1'b1;
    assign mux_in[3] = mux3_out;

endmodule