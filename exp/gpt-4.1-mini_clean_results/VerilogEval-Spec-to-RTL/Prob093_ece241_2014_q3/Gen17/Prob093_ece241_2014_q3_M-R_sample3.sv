module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] (ab=00):
    // For cd:
    // 00->0, 01->1, 11->1, 10->1
    // Use c as selector:
    // if c=0 -> output d
    // if c=1 -> output 1
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1] (ab=01):
    // Always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11):
    // For cd:
    // 00->0, 01->0, 11->1, 10->0
    // Use c as selector:
    // if c=0 -> output 0
    // if c=1 -> output d
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3] (ab=10):
    // For cd:
    // 00->1, 01->0, 11->1, 10->1
    // Use d as selector:
    // if d=0 -> output 1
    // if d=1 -> output c
    assign mux_in[3] = d ? c : 1'b1;

endmodule