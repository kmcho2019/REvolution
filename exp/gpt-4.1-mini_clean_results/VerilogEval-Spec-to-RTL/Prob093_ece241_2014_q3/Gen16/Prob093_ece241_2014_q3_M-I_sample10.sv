module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // For ab=00 (mux_in[0]):
    // Output=1 except when c=0,d=0 (output=0)
    // Equivalent to: c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // For ab=01 (mux_in[1]):
    // Output=0 always
    assign mux_in[1] = 1'b0;

    // For ab=11 (mux_in[2]):
    // Output=1 only when c=1 and d=1
    // Equivalent to c & d implemented as: c ? d : 0
    assign mux_in[2] = c ? d : 1'b0;

    // For ab=10 (mux_in[3]):
    // Output=0 only when c=0 and d=1, else 1
    // Equivalent to c | ~d
    // Implement ~d as mux: d ? 0 : 1
    assign mux_in[3] = c ? 1'b1 : (d ? 1'b0 : 1'b1);
endmodule