module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // For ab=00 (mux_in[0]):
    // Outputs from K-map:
    // cd=00 (c=0,d=0) -> 0
    // cd=01 (c=0,d=1) -> 1
    // cd=11 (c=1,d=1) -> 1
    // cd=10 (c=1,d=0) -> 1
    // So, if c=0, output = d, else output = 1
    assign mux_in[0] = c ? 1'b1 : d;

    // For ab=01 (mux_in[1]):
    // All zero according to K-map
    assign mux_in[1] = 1'b0;

    // For ab=11 (mux_in[2]):
    // cd=00 ->0, 01->0, 11->1, 10->0
    // This is c AND d implemented as mux: c ? d : 0
    assign mux_in[2] = c ? d : 1'b0;

    // For ab=10 (mux_in[3]):
    // cd=00->1, 01->0, 11->1, 10->1
    // Output = if d=0 output 1 else output c
    assign mux_in[3] = d ? c : 1'b1;

endmodule