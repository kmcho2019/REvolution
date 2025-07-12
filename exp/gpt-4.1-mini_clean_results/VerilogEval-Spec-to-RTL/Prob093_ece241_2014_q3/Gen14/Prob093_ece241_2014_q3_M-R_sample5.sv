module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] for ab=00:
    // Implement c OR d as mux with c as select:
    // If c=0, output d; else output 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01:
    // All zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11:
    // Implement c AND d as mux with c as select:
    // If c=1, output d; else output 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] for ab=10:
    // Implement c OR ~d as mux with c as select:
    // If c=1, output 1; else output ~d
    assign mux_in[3] = c ? 1'b1 : ~d;

endmodule