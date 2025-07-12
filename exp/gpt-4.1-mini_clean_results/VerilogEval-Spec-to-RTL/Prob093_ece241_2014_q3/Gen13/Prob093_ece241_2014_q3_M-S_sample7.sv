module TopModule (
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);
    // Implement NOT d using a 2-to-1 mux: ~d = d ? 0 : 1
    wire nd = d ? 1'b0 : 1'b1;

    // mux_in[0]: ab=00 -> function c OR d = c ? 1 : d
    assign mux_in[0] = c ? 1'b1 : d;

    // mux_in[1]: ab=01 -> always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 -> function c AND d = c ? d : 0
    assign mux_in[2] = c ? d : 1'b0;

    // mux_in[3]: ab=10 -> function c OR ~d = c ? 1 : ~d
    assign mux_in[3] = c ? 1'b1 : nd;

endmodule