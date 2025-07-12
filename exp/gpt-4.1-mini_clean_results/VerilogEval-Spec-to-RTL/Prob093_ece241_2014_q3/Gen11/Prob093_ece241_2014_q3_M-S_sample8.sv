module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output [3:0] mux_in
);
    // K-map values per ab (selector) for cd inputs:
    // ab=00 (mux_in[0]): cd=00:0, 01:1, 11:1, 10:1
    // Implement using 2-to-1 muxes:
    // cd inputs: c=0,d=0->0; c=0,d=1->1; c=1,d=0->1; c=1,d=1->1
    // mux_in[0] = c ? 1 : d; // if c=1 output 1 else output d

    // ab=01 (mux_in[1]): all zero
    // mux_in[1] = 0;

    // ab=11 (mux_in[2]): cd=00:0, 01:0, 11:1, 10:0
    // For c=0 output 0 else output d
    // mux_in[2] = c ? d : 0;

    // ab=10 (mux_in[3]): cd=00:1, 01:0, 11:1, 10:1
    // For c=0 output ~d, for c=1 output 1
    // Since inversion is not allowed, express ~d as mux(1,0,d)
    // ~d = d ? 0 : 1
    // mux_in[3] = c ? 1 : (d ? 0 : 1);

    assign mux_in[0] = c ? 1'b1 : d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = c ? d : 1'b0;
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);

endmodule