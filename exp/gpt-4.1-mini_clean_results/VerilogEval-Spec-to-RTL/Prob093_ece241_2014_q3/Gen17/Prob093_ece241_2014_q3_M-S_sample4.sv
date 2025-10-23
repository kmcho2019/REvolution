module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // From K-map:
    // For each mux_in[i] (ab selector):
    // Values correspond to cd=00,01,11,10 in that order.
    //
    // mux_in[0] (ab=00): cd=00:0, 01:1, 11:1, 10:1
    // mux_in[1] (ab=01): cd=00:0, 01:0, 11:0, 10:0
    // mux_in[2] (ab=11): cd=00:0, 01:0, 11:1, 10:0
    // mux_in[3] (ab=10): cd=00:1, 01:0, 11:1, 10:1

    // Helper: nested mux for each bit
    // For input cd:
    // if c==0: select between cd=00(d=0) and cd=01(d=1)
    // if c==1: select between cd=10(d=0) and cd=11(d=1)
    // Note cd=11 is c=1,d=1; cd=10 is c=1,d=0; cd=01 is c=0,d=1; cd=00 is c=0,d=0

    // mux_in[0]:
    // c=0: d=0->0, d=1->1
    // c=1: d=0->1, d=1->1
    assign mux_in[0] = c ? (d ? 1'b1 : 1'b1) : (d ? 1'b1 : 1'b0);

    // mux_in[1]: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2]:
    // c=0: d=0->0, d=1->0
    // c=1: d=0->0, d=1->1
    assign mux_in[2] = c ? (d ? 1'b1 : 1'b0) : 1'b0;

    // mux_in[3]:
    // c=0: d=0->1, d=1->0
    // c=1: d=0->1, d=1->1
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);

endmodule