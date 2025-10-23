module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] for ab=00:
    // From K-map: 0,1,1,1 for cd=00,01,11,10
    // Implement as: if c=1 output 1 else output d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] for ab=01:
    // All zero column in K-map
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11:
    // Only 1 when c=1 and d=1
    // Implement as mux with c select: if c=1 output d else 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] for ab=10:
    // Outputs 1 except at cd=01 (c=0,d=1) -> 0
    // Implement as mux with d select: if d=1 output c else 1
    assign mux_in[3] = d ? c : 1'b1;

endmodule